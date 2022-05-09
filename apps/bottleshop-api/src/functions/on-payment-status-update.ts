/* eslint-disable no-case-declarations */
/* eslint-disable @typescript-eslint/no-explicit-any */
import * as admin from 'firebase-admin';
import express from 'express';
import * as functions from 'firebase-functions';
import Stripe from 'stripe';

import {
  Cart,
  CartRecord,
} from '../models/cart';
import {
  cartCollection,
  cartItemsSubCollection,
  ordersCollection,
  orderTypesCollection,
  productsCollection,
  promoCodesCollection,
  usersCollection,
} from '../constants/collections';
import { DeliveryType } from '../models/order-type';
import { getCartTotalPrice } from '../utils/cart-utils';
import { getEntityByRef } from '../utils/document-reference-utils';
import {
  Order,
  OrderItem,
} from '../models/order';
import { Product } from '../models/product';
import { productFields } from '../constants/model-constants';
import { PromoCode } from '../models/promo-code';
import {
  tempCartId,
  tier1Region,
  VAT,
} from '../constants/other';
import { User } from '../models/user';

const stripe = new Stripe(functions.config().stripe.api_key, {
  typescript: true,
  apiVersion: '2020-08-27',
});
const webhookSecret: string = functions.config().stripe.webhook_secret;

function getCartRef(userId: string): FirebaseFirestore.DocumentReference {
  return admin.firestore().collection(`${usersCollection}/${userId}/${cartCollection}`).doc(tempCartId);
}

function getCart(userId: string): Promise<Cart | undefined> {
  return getEntityByRef<Cart>(getCartRef(userId));
}

async function getOrderItems(userId: string): Promise<OrderItem[]> {
  const itemsSnap = await getCartRef(userId).collection(cartItemsSubCollection).get();

  const orderItems: OrderItem[] = [];
  for (const item of itemsSnap.docs) {
    const cartRecord: CartRecord = item.data() as CartRecord;
    const productDoc = await cartRecord.product_ref.get();
    const product = productDoc.data() as Product;
    if (product) {
      const paidPrice = product.price_no_vat * cartRecord.quantity * (1 + VAT) * (1 - (product.discount ?? 0));

      const cartItem: OrderItem = {
        product,
        paid_price: paidPrice,
        count: cartRecord.quantity,
      };
      orderItems.push(cartItem);
    }
  }

  return orderItems;
}

export async function createOrder(
  userId: string,
  deliveryType: DeliveryType,
  orderId: number,
  orderNote = '',
): Promise<[string, Cart] | undefined> {
  if (userId == null || deliveryType == null) {
    return Promise.reject('createOrder failed: userId or deliveryType undefined - bad request');
  }

  const orderItems: OrderItem[] = await getOrderItems(userId);
  if (orderItems.length === 0) {
    return Promise.reject('createOrder failed: orderItems empty - bad request');
  }

  const [orderTypeDoc, customer, cart] = await Promise.all([
    admin.firestore().collection(orderTypesCollection).where('code', '==', deliveryType).get(),
    getEntityByRef<User>(admin.firestore().collection(usersCollection).doc(userId)),
    getCart(userId),
  ]);

  if (cart == null || customer == null) {
    return Promise.reject('createOrder failed: cart or customer is null - bad request');
  }

  const orderTypeRef = orderTypeDoc.docs[0].ref;
  const ordersCollectionRef = admin.firestore().collection(ordersCollection);
  const timeStamp = admin.firestore.Timestamp.now();

  const newOrder: Order = {
    promo_code: cart.promo_code,
    promo_code_value: cart.promo_code_value,
    id: orderId,
    cart: orderItems,
    created_at: timeStamp,
    customer,
    note: orderNote,
    order_type_ref: orderTypeRef,
    status_step_id: 0,
    status_timestamps: [timeStamp],
    total_paid: getCartTotalPrice(cart),
    oasis_synced: false,
  };
  const created = await ordersCollectionRef.add(newOrder);
  return [created.id, cart];
}

export async function updatePromoCodeUses(promoId: string | undefined) {
  if (promoId) {
    await admin.firestore().runTransaction(async () => {
      const promoRef = admin.firestore().collection(promoCodesCollection).doc(promoId);
      const promoDoc = await promoRef.get();
      if (promoDoc.exists) {
        const promo = promoDoc.data() as PromoCode;
        const newRemainingUsesCount = promo.remaining_uses_count > 0 ? promo.remaining_uses_count - 1 : 0;
        await promoRef.update({ remaining_uses_count: newRemainingUsesCount });
      }
    });
  }
}

export async function deleteCartItems(userId: string) {
  const db = admin.firestore();
  const cartRef = db.collection(usersCollection).doc(userId).collection('cart').doc('temp_cart').collection('items');
  const batch = db.batch();
  const documents = await cartRef.listDocuments();
  for (const doc of documents) {
    batch.delete(doc);
  }
  await batch.commit();
}

export async function updateProductStockCounts(userId: string): Promise<void> {
  const cartItems: OrderItem[] = await getOrderItems(userId);
  await admin.firestore().runTransaction(async () =>
    Promise.all(
      cartItems.map(async (item) => {
        const prodRef = admin.firestore().collection(productsCollection).doc(item.product.cmat);

        const product = await getEntityByRef<Product>(prodRef);
        if (product == null) {
          return undefined;
        }
        return prodRef
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

const app = express();

app.post('/', async (req: express.Request, res: express.Response) => {
  try {
    const firebaseRequest = req as functions.https.Request;
    const signature = firebaseRequest.headers['stripe-signature'] as string | string[] | Buffer;
    const event = stripe.webhooks.constructEvent(firebaseRequest.rawBody, signature, webhookSecret);
    const eventType: string = event.type;
    switch (eventType) {
      case 'checkout.session.completed':
        functions.logger.log('handler checkout.session.completed invoked');
        const session = event.data.object as any;
        functions.logger.log(`session data: ${JSON.stringify(session)}`);
        const orderDocId = await admin.firestore().runTransaction<string | undefined>(async () => {
          const result = await createOrder(
            session.metadata.userId,
            session.metadata.deliveryType as DeliveryType,
            parseInt(session.metadata.orderId, 10),
            session.metadata.orderNote,
          );
          if (!result) {
            return undefined;
          }
          const [orderDoc, cart] = result;

          // First update stock counts and promo counts and after that delete cart items
          await Promise.all([
            updateProductStockCounts(session.metadata.userId),
            updatePromoCodeUses(cart.promo_code || undefined),
          ]);
          await deleteCartItems(session.metadata.userId);

          return orderDoc;
        });
        functions.logger.log(`checkout.session.completed ${orderDocId}`);

        if (!orderDocId) {
          functions.logger.error('Order couldnt be created');
          return res.sendStatus(500);
        }
        return res.sendStatus(200);

      case 'payment_intent.succeeded':
        functions.logger.log('handler for payment_intent.succeeded invoked');
        const data: Stripe.Event.Data = event.data;
        const pi = data.object as Stripe.PaymentIntent;
        if (pi.metadata && pi.metadata.userId && pi.metadata.orderId) {
          const { userId, deliveryType, orderNote, orderId } = pi.metadata;
          functions.logger.log(`payment_intent.succeeded: ${userId} ${deliveryType} ${orderNote} ${orderId}`);
          const oId = await admin.firestore().runTransaction<string | undefined>(async () => {
            const result = await createOrder(userId, deliveryType as DeliveryType, parseInt(orderId, 10), orderNote);
            if (result == null) {
              return undefined;
            }
            const [orderDoc, cart] = result;

            // First update stock counts and promo counts and after that delete cart items
            await Promise.all([updateProductStockCounts(userId), updatePromoCodeUses(cart.promo_code || undefined)]);
            await deleteCartItems(userId);

            return orderDoc;
          });
          functions.logger.log(`payment_intent.succeeded ${oId}`);

          if (!oId) {
            functions.logger.error('Order couldnt be created');
            return res.sendStatus(500);
          }
          return res.sendStatus(200);
        }
        return res.sendStatus(200);

      default:
        functions.logger.warn(`handler ${eventType} invoked but ignored`);
        return res.sendStatus(200);
    }
  } catch (err) {
    functions.logger.error('Webhook failed', err);
    res.sendStatus(400);
  }
  return res.sendStatus(200);
});

export const onPaymentStatusUpdate = functions.region(tier1Region).https.onRequest(app);
