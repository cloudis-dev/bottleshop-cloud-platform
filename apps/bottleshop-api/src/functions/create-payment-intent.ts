import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

import { ordersCollection, usersCollection } from '../constants/collections';
import { Order } from '../models/order';
import { User } from '../models/user';
import { PaymentData } from '../models/payment-data';
import { tier1Region } from '../constants/other';
import { getEntityByRef } from '../utils/document-reference-utils';
import { getCart, getCartTotalPrice } from '../utils/cart-utils';
import { createStripeClient } from '..';

export async function generateNewOrderId(): Promise<string> {
  const ordersCollectionRef = admin.firestore().collection(ordersCollection);
  const orders = await ordersCollectionRef.orderBy('id', 'desc').limit(1).get();

  return (orders.empty ? 1 : (orders.docs[orders.size - 1].data() as Order).id + 1).toString();
}

export const createPaymentIntent = functions
  .region(tier1Region)
  .runWith({ allowInvalidAppCheckToken: true })
  .https.onCall(async (data: PaymentData, context) => {
    const userUid = context.auth?.uid;

    if (userUid === undefined) {
      return { access: 'denied' };
    }

    try {
      const user = await getEntityByRef<User>(admin.firestore().collection(usersCollection).doc(userUid));
      const cart = await getCart(userUid);

      if (cart === undefined || user === undefined) {
        return { error: 'bad request' };
      }

      const stripe = createStripeClient();
      const orderId = await generateNewOrderId();
      return await stripe.paymentIntents.create({
        amount: +(getCartTotalPrice(cart) * 100).toFixed(0),
        description: `Bottleshop 3 Veze #${orderId}`,
        customer: user.stripe_customer_id,
        currency: 'eur',
        payment_method_types: ['card'],
        metadata: {
          platform: 'mobile',
          userId: userUid,
          deliveryType: data.deliveryType,
          orderNote: data.orderNote || '',
          orderId,
        },
      });
    } catch (e) {
      functions.logger.error(`payment failed ${e}`);
      return e;
    }
  });
