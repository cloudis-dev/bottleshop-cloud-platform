import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import Stripe from 'stripe';

import { Cart } from '../models/cart';
import {
  cartCollection,
  ordersCollection,
  usersCollection,
} from '../constants/collections';
import { getCartTotalPrice } from '../utils/cart-utils';
import { getEntityByRef } from '../utils/document-reference-utils';
import { Order } from '../models/order';
import { PaymentData } from '../models/payment-data';
import {
  tempCartId,
  tier1Region,
} from '../constants/other';

const stripe = new Stripe(functions.config().stripe.api_key, {
  typescript: true,
  apiVersion: '2020-08-27',
});

export async function generateNewOrderId(): Promise<string> {
  const ordersCollectionRef = admin.firestore().collection(ordersCollection);
  const orders = await ordersCollectionRef.orderBy('id', 'desc').limit(1).get();

  return (orders.empty ? 1 : (orders.docs[orders.size - 1].data() as Order).id + 1).toString();
}

export const createPaymentIntent = functions.region(tier1Region).https.onCall(async (data: PaymentData, context) => {
  if (!context.app) {
    throw new functions.https.HttpsError(
      'failed-precondition',
      'The function must be called from an App Check verified app.',
    );
  }
  try {
    if (context.auth && context.auth.uid) {
      const cartRef = admin
        .firestore()
        .collection(usersCollection)
        .doc(data.userId)
        .collection(cartCollection)
        .doc(tempCartId);
      const cart: Cart | undefined = await getEntityByRef<Cart>(cartRef);
      if (cart) {
        const orderId = await generateNewOrderId();
        return await stripe.paymentIntents.create({
          amount: +(getCartTotalPrice(cart) * 100).toFixed(0),
          description: `Bottleshop 3 Veze #${orderId}`,
          customer: data.customerId,
          currency: 'eur',
          payment_method_types: ['card'],
          metadata: {
            platform: 'mobile',
            userId: data.userId,
            deliveryType: data.deliveryType,
            orderNote: data.orderNote || '',
            orderId,
          },
        });
      } else {
         return { error: 'bad request'}
        }
    } else {
      return { access: 'denied' };
    }
  } catch (e) {
    functions.logger.error(`payment failed ${e}`);
    return e;
  }
});
