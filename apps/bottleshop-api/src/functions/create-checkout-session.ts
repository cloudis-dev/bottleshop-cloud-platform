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
import { calculateOrderTypeFinalPrice, generateNewOrderId, getOrderTypeByCode } from '../utils/order-utils';
import { getPromoByCode, isPromoValid } from '../utils/promo-code-utils';

export const createCheckoutSession = functions
  .region(tier1Region)
  .runWith({ allowInvalidAppCheckToken: true })
  .https.onCall(async (data: PaymentData, context: functions.https.CallableContext) => {
    const userUid = context.auth?.uid;
    if (userUid === undefined) {
      return new functions.https.HttpsError('unauthenticated', 'Request is unauthenticated');
    }

    // Cart check

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

    // Products check

    const [areProductsPurchasable, productLineItems] = await Promise.all([
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

    if (!areProductsPurchasable) {
      return new functions.https.HttpsError('failed-precondition', 'Not all products are purchasable.');
    }

    // Promos check

    const promoLineItems = await (async () => {
      if (data.promoCode !== undefined) {
        const promo = await getPromoByCode(data.promoCode);
        if (promo === undefined) {
          return undefined;
        }

        if (!isPromoValid(promo, cart)) {
          return undefined;
        }

        return [
          {
            price_data: {
              currency: 'eur',
              product_data: {
                name: `Promo: ${data.promoCode}`,
                images: [],
              },
              unit_amount: Math.round(promo.discount_value * 100),
            },
            quantity: 1,
          },
        ];
      }

      return [];
    })();

    if (promoLineItems === undefined) {
      return new functions.https.HttpsError(
        'failed-precondition',
        'Promo code either does not exist, or the cart have not met preconditions.',
      );
    }

    const orderType = await getOrderTypeByCode(data.deliveryType);

    if (orderType === undefined) {
      return new functions.https.HttpsError('failed-precondition', 'No such order type exists.');
    }

    const orderTypeLineItem = [
      {
        price_data: {
          currency: 'eur',
          product_data: {
            name: 'Shipping',
            images: [],
          },
          unit_amount: Math.round(calculateOrderTypeFinalPrice(orderType) * 100),
        },
        quantity: 1,
      },
    ];

    const stripe = createStripeClient();
    const orderId = await generateNewOrderId();
    const metadata: StripePaymentMetadata = {
      userId: userUid,
      orderId,
      platform: data.platform,
      deliveryType: data.deliveryType,
      orderNote: data.orderNote.trim() === '' ? data.orderNote.trim() : undefined,
    };

    const session = await stripe.checkout.sessions.create({
      payment_method_types: ['card'],
      line_items: productLineItems.concat(promoLineItems).concat(orderTypeLineItem),
      metadata: metadata as unknown as Stripe.MetadataParam,
      mode: 'payment',
      success_url: data.successUrl,
      cancel_url: data.cancelUrl,
    });

    return session.id;
  });
