import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import Stripe from 'stripe';
import { tempCartId, tier1Region } from '../constants/other';
import { cartCollection, usersCollection } from '../constants/collections';
import { Cart } from '../models/cart';
import { getEntityByRef } from '../utils/document-reference-utils';
import { getCartItems } from '../utils/cart-utils';
import { calculateProductFinalPrice, getProductImageUrl } from '../utils/product-utils';

export const createCheckoutSession = functions
  .region(tier1Region)
  .runWith({ allowInvalidAppCheckToken: true })
  .https.onCall(async (data: { cancel_url: string; success_url: string }, context: functions.https.CallableContext) => {
    const userUid = context.auth?.uid;
    if (userUid === undefined) {
      return Promise.reject('Request is unauthenticated');
    }

    const cartRef = admin
      .firestore()
      .collection(usersCollection)
      .doc(userUid)
      .collection(cartCollection)
      .doc(tempCartId);
    const cart: Cart | undefined = await getEntityByRef<Cart>(cartRef);

    if (cart === undefined) {
      return Promise.reject(`No cart found for user ${userUid}`);
    }

    const stripe = new Stripe(functions.config().stripe.secret_key, {
      typescript: true,
      apiVersion: '2020-08-27',
    });

    const cartItems = await getCartItems(userUid);

    const session = await stripe.checkout.sessions.create({
      payment_method_types: ['card'],
      line_items: cartItems.map((item) => {
        const productUrl = getProductImageUrl(item.product);

        return {
          price_data: {
            currency: 'eur',
            product_data: {
              name: item.product.name,
              images: productUrl === undefined ? [] : [productUrl],
            },
            unit_amount: Math.round(calculateProductFinalPrice(item.product) * 100),
          },
          quantity: item.quantity,
        };
      }),
      mode: 'payment',
      success_url: data.success_url,
      cancel_url: data.cancel_url,
    });

    return session.id;
  });
