import ejs from 'ejs';
import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import { approximately } from './math-utils';
import { DeliveryType, OrderType } from '../models/order-type';
import { formatDate } from './time-utils';
import { getPriceNumberString } from './formatting-utils';
import { Language, VAT } from '../constants/other';
import { Order, OrderItem } from '../models/order';
import { User } from '../models/user';
import { ordersCollection, orderTypesCollection, usersCollection } from '../constants/collections';
import { usePromoCode } from './promo-code-utils';
import { deleteAllCartItems, getCart, getCartItems, getCartTotalPrice } from './cart-utils';
import { getProduct, getProductRef } from './product-utils';
import { productFields } from '../constants/model-constants';
import { getEntityByRef } from './document-reference-utils';

export async function generateNewOrderId(): Promise<string> {
  const ordersCollectionRef = admin.firestore().collection(ordersCollection);
  const orders = await ordersCollectionRef.orderBy('id', 'desc').limit(1).get();

  return (orders.empty ? 1 : (orders.docs[orders.size - 1].data() as Order).id + 1).toString();
}

export async function getOrderTypeByCode(
  shippingCode: DeliveryType,
): Promise<[OrderType, FirebaseFirestore.DocumentReference] | undefined> {
  const docs = await admin.firestore().collection(orderTypesCollection).where('code', '==', shippingCode).get();
  if (docs.empty) {
    return undefined;
  }
  const ref = docs.docs[0];
  return [ref.data() as OrderType, ref.ref];
}

export function calculateOrderTypeFinalPrice(orderType: OrderType): number {
  return +(orderType.shipping_fee_eur_no_vat * (1 + VAT)).toFixed(2);
}

async function getOrderItems(userId: string): Promise<OrderItem[]> {
  return getCartItems(userId).then((items) =>
    items.map((item) => {
      const paidPrice = item.product.price_no_vat * item.quantity * (1 + VAT) * (1 - (item.product.discount ?? 0));
      return {
        product: item.product,
        paid_price: paidPrice,
        count: item.quantity,
      };
    }),
  );
}

async function updateProductStockCounts(userId: string): Promise<void> {
  const cartItems: OrderItem[] = await getOrderItems(userId);
  await admin.firestore().runTransaction(async () =>
    Promise.all(
      cartItems.map(async (item) => {
        const product = await getProduct(item.product.cmat);

        if (product === undefined) {
          return undefined;
        }

        return getProductRef(item.product.cmat)
          .update({
            [productFields.countField]: Math.max(0, product.amount - item.count),
          })
          .catch(() =>
            functions.logger.info(
              `Could not update product amount in warehouse from cart. Quantity to decrease: ${item.count}, Product: ${product}`,
            ),
          );
      }),
    ),
  );
}

/**
 * Run create order effect - create order for the user, empty his cart,
 * update product stock counts and updates promo code uses if any.
 *
 * Returns order document id.
 * @param userId
 * @param deliveryType
 * @param orderId
 * @param orderNote
 * @param promoCode
 * @param total_paid
 */
export async function createOrderEffect(
  userId: string,
  deliveryType: DeliveryType,
  orderId: number,
  orderNote = '',
  promoCode: { code: string; discountValue: number } | undefined,
  total_paid: number | undefined,
): Promise<string> {
  return admin.firestore().runTransaction<string>(async () => {
    if (!userId || !deliveryType) {
      return Promise.reject('createOrder failed: userId or deliveryType undefined - bad request');
    }

    const orderItems: OrderItem[] = await getOrderItems(userId);
    if (orderItems.length === 0) {
      return Promise.reject('createOrder failed: orderItems empty - bad request');
    }

    const [orderTypeRef, customer, cart] = await Promise.all([
      getOrderTypeByCode(deliveryType).then((a) => a?.[1]),
      getEntityByRef<User>(admin.firestore().collection(usersCollection).doc(userId)),
      getCart(userId),
    ]);

    if (cart === undefined || customer === undefined || orderTypeRef === undefined) {
      return Promise.reject('createOrder failed: cart or customer is null - bad request');
    }

    const ordersCollectionRef = admin.firestore().collection(ordersCollection);
    const timeStamp = admin.firestore.Timestamp.now();

    const [promo_code, promo_code_value] =
      promoCode === undefined ? [cart.promo_code, cart.promo_code_value] : [promoCode.code, promoCode.discountValue];

    const newOrder: Order = {
      promo_code: promo_code,
      promo_code_value: promo_code_value,
      id: orderId,
      cart: orderItems,
      created_at: timeStamp,
      customer,
      note: orderNote,
      order_type_ref: orderTypeRef,
      status_step_id: 0,
      status_timestamps: [timeStamp],
      total_paid: total_paid ?? getCartTotalPrice(cart),
      oasis_synced: false,
    };
    const created = await ordersCollectionRef.add(newOrder);

    // First update stock counts and promo counts and after that delete cart items
    await Promise.all([
      updateProductStockCounts(userId),
      usePromoCode(promoCode?.code || cart.promo_code || undefined),
    ]);
    await deleteAllCartItems(userId);

    return created.id;
  });
}

export function getStatusStepNotificationTitle(
  stepId: number,
  order: Order,
  deliveryType: DeliveryType,
  lang: Language,
): string | undefined {
  switch (stepId) {
    case 0:
      if (lang === 'sk') {
        return `Ďakujeme za Vašu objednávku #${order.id}`;
      } else {
        return `Thank you for your order #${order.id}`;
      }
    case 1:
      if (deliveryType === 'pick-up') {
        if (lang === 'sk') {
          return `Vaša objednávka #${order.id} je pripravená na vyzdvihnutie na predajni Bottleshop Tri Veže`;
        } else {
          return `Your order #${order.id} is ready for pick-up at Bottleshop Tri Veže`;
        }
      } else {
        if (lang === 'sk') {
          return `Vaša objednávka #${order.id} je pripravená na odoslanie na Vami určenú adresu`;
        } else {
          return `Order #${order.id} is ready to be shipped`;
        }
      }

    case 2:
      if (lang === 'sk') {
        return `Vaša objednávka #${order.id} bola odoslaná na Vami určenú adresu`;
      } else {
        return `Your order #${order.id} was shipped to your specified location`;
      }
    case 3:
      if (deliveryType === 'pick-up') {
        if (lang === 'sk') {
          return `Vaša objednávka #${order.id} bola vyzdvihnutá na predajni Bottleshop Tri Veže`;
        } else {
          return `Your order #${order.id} was picked-up at Bottleshop Tri Veže`;
        }
      } else {
        if (lang === 'sk') {
          return `Vaša objednávka #${order.id} bola doručená na Vašej adrese`;
        } else {
          return `Your order #${order.id} was delivered to your specified location`;
        }
      }
    default:
      return undefined;
  }
}

export function getStatusStepMailDescription(
  stepId: number,
  deliveryType: DeliveryType,
  lang: Language,
): string | undefined {
  switch (stepId) {
    case 0:
      if (lang === 'sk') {
        return 'Vaša objednávka bola prijatá a aktuálne sa spracováva.';
      } else {
        return 'Your order has been received and is currently being processed.';
      }
    case 1:
      if (deliveryType === 'pick-up') {
        if (lang === 'sk') {
          return 'Vaša objednávka je pripravená na vyzdvihnutie na predajni Bottleshop Tri Veže.';
        } else {
          return 'Your order is ready for pick-up at Bottleshop Tri Veže.';
        }
      } else {
        if (lang === 'sk') {
          return 'Vaša objednávka je pripravená na odoslanie na Vami určenú adresu.';
        } else {
          return 'Your order is ready to be shipped to your specified location.';
        }
      }
    case 2:
      if (lang === 'sk') {
        return 'Vaša objednávka bola odoslaná na Vami určenú adresu.';
      } else {
        return 'Your order was shipped to your specified location.';
      }
    case 3:
      if (deliveryType === 'pick-up') {
        if (lang === 'sk') {
          return 'Vaša objednávka bola vyzdvihnutá na predajni Bottleshop Tri Veže.';
        } else {
          return 'Your order was picked-up at Bottleshop Tri Veže.';
        }
      } else {
        if (lang === 'sk') {
          return 'Vaša objednávka bola doručená na Vašej adrese.';
        } else {
          return 'Your order was delivered to your specified location.';
        }
      }

    default:
      return undefined;
  }
}

export function getMailSubject(
  orderStepId: number,
  order: Order,
  orderType: OrderType,
  lang: Language,
): string | undefined {
  switch (orderStepId) {
    case 0:
      if (lang === 'sk') {
        return `Bottleshop Tri Veže: Objednávka #${order.id} prijatá`;
      } else {
        return `Bottleshop Tri Veže: Order #${order.id} acceptance`;
      }
    case 1:
      if (orderType.code === 'pick-up') {
        if (lang === 'sk') {
          return `Bottleshop Tri Veže: Objednávka #${order.id} pripravená na vyzdvihnutie`;
        } else {
          return `Bottleshop Tri Veže: Order #${order.id} ready for pick-up`;
        }
      }

      if (lang === 'sk') {
        return `Bottleshop Tri Veže: Objednávka #${order.id} pripravená na odoslanie`;
      } else {
        return `Bottleshop Tri Veže: Order #${order.id} is ready to be shipped`;
      }
    case 2:
      if (lang === 'sk') {
        return `Bottleshop Tri Veže: Objednávka #${order.id} bola odoslaná`;
      } else {
        return `Bottleshop Tri Veže: Order #${order.id} was shipped`;
      }
    case 3:
      if (lang === 'sk') {
        return `Bottleshop Tri Veže: Objednávka #${order.id} vybavená`;
      } else {
        return `Bottleshop Tri Veže: Order #${order.id} completed`;
      }
    default:
      return undefined;
  }
}

export function getMailBodyHtml(
  orderStepId: number,
  order: Order,
  orderType: OrderType,
  customer: User,
  lang: Language,
): Promise<string> {
  const stateDescription = getStatusStepMailDescription(orderStepId, orderType.code, lang);

  return new Promise<string>((resolve, reject) => {
    const data = {
      userName: customer.name,
      userPhone: customer.phone_number,
      displayShippingAddress: orderType.code !== 'pick-up',
      isCashOnDelivery: orderType.code === 'cash-on-delivery',
      addressFirstLine: `${customer.shipping_address?.streetName} ${customer.shipping_address?.streetNumber}`,
      addressSecondLine: `${customer.shipping_address?.zipCode} ${customer.shipping_address?.city}`,
      orderStateDescription: stateDescription,
      orderCreated: formatDate(order.created_at.toDate()),
      orderId: order.id,
      totalPaid: `€${getPriceNumberString(order.total_paid)}`,
      orderTypeName: lang === 'sk' ? orderType.localized_name.sk : orderType.name,
      hasShippingFee: !approximately(orderType.shipping_fee_eur_no_vat, 0),
      shippingFee: `€${getPriceNumberString(orderType.shipping_fee_eur_no_vat * (1 + VAT))}`,
      hasNote: (order.note?.length ?? 0) > 0,
      note: order.note,
      hasPromo: order.promo_code !== undefined,
      promoCode: order.promo_code,
      promoValue: `-€${getPriceNumberString(order.promo_code_value ?? 0)}`,
      cartItems: order.cart.map((e) => {
        return {
          itemName: e.product.name,
          hasDiscount: !approximately(e.product.discount ?? 0, 0),
          itemsCount: e.count,
          itemPaidPrice: `€${getPriceNumberString(e.paid_price)}`,
          itemWithoutDiscountPrice: `€${getPriceNumberString(e.paid_price * (1 + (e.product.discount ?? 0)))}`,
        };
      }),
    };

    ejs.renderFile(
      lang === 'sk' ? '/workspace/order-created_sk.html' : '/workspace/order-created_en.html',
      data,
      (err, result) => {
        if (err) {
          reject(err);
        } else {
          resolve(result);
        }
      },
    );
  });
}
