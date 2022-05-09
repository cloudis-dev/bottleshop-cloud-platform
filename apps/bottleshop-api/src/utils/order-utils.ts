import ejs from 'ejs';

import { approximately } from './math-utils';
import {
  DeliveryType,
  OrderType,
} from '../models/order-type';
import { formatDate } from './time-utils';
import { getPriceNumberString } from './formatting-utils';
import {
  Language,
  VAT,
} from '../constants/other';
import { Order } from '../models/order';
import { User } from '../models/user';

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
      hasPromo: order.promo_code != null,
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
      lang === 'sk' ? '/workspace/templates/order-created_sk.html' : '/workspace/templates/order-created_en.html',
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
