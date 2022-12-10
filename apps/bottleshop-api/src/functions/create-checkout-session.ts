import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import Stripe from 'stripe';
import { tempCartId, tier1Region } from '../constants/other';
import { cartCollection, usersCollection } from '../constants/collections';
import { Cart } from '../models/cart';
import { getEntityByRef } from '../utils/document-reference-utils';
import { areProductsAvailableForPurchase, getCartItems } from '../utils/cart-utils';
import { calculateProductFinalPrice, getProductImageUrl } from '../utils/product-utils';
import { PaymentData, StripePaymentMetadata } from '../models/payment-data';
import { createStripeClient } from '..';

export const createCheckoutSession = functions
  .region(tier1Region)
  .runWith({ allowInvalidAppCheckToken: true })
  .https.onCall(async (data: PaymentData, context: functions.https.CallableContext) => {
    const userUid = context.auth?.uid;
    if (userUid === undefined) {
      return new functions.https.HttpsError('unauthenticated', 'Request is unauthenticated');
    }

    const cartRef = admin
      .firestore()
      .collection(usersCollection)
      .doc(userUid)
      .collection(cartCollection)
      .doc(tempCartId);

    const [cart, cartItems] = await Promise.all([getEntityByRef<Cart>(cartRef), getCartItems(userUid)]);

    if (cart === undefined) {
      return new functions.https.HttpsError('failed-precondition', `No cart found for user ${userUid}`);
    }

    const [productsPurchasable, line_items] = await Promise.all([
      areProductsAvailableForPurchase(cartItems),
      Promise.all(
        cartItems.map(async (item) => {
          const productUrl = await getProductImageUrl(item.product);

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
      ),
    ]);

    if (!productsPurchasable) {
      return new functions.https.HttpsError('failed-precondition', 'Not all products are purchasable.');
    }

    const stripe = createStripeClient();
    const metadata: StripePaymentMetadata = {
      platform: data.platform,
      deliveryType: data.deliveryType,
      orderNote: data.orderNote.trim() === '' ? data.orderNote.trim() : undefined,
    };

    const session = await stripe.checkout.sessions.create({
      payment_method_types: ['card'],
      line_items: line_items,
      metadata: metadata as unknown as Stripe.MetadataParam,
      mode: 'payment',
      success_url: data.successUrl,
      cancel_url: data.cancelUrl,
    });

    return session.id;
  });
