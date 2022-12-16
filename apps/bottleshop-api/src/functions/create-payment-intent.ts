import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

import { usersCollection } from '../constants/collections';
import { User } from '../models/user';
import { PaymentData, StripePaymentMetadata } from '../models/payment-data';
import { tier1Region } from '../constants/other';
import { getEntityByRef } from '../utils/document-reference-utils';
import { getCart, getCartTotalPrice } from '../utils/cart-utils';
import { createStripeClient } from '..';
import Stripe from 'stripe';
import { generateNewOrderId } from '../utils/order-utils';

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
      const metadata: StripePaymentMetadata = {
        platform: 'mobile',
        userId: userUid,
        deliveryType: data.deliveryType,
        orderNote: data.orderNote || '',
        orderId,
        promoCode: undefined,
      };
      return await stripe.paymentIntents.create({
        amount: +(getCartTotalPrice(cart) * 100).toFixed(0),
        description: `Bottleshop 3 Veze #${orderId}`,
        customer: user.stripe_customer_id,
        currency: 'eur',
        payment_method_types: ['card'],
        metadata: metadata as unknown as Stripe.MetadataParam,
      });
    } catch (e) {
      functions.logger.error(`payment failed ${e}`);
      return e;
    }
  });
