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
import { User } from '../models/user';

export const createCheckoutSession = functions
  .region(tier1Region)
  .runWith({ allowInvalidAppCheckToken: true })
  .https.onCall(async (data: PaymentData, context: functions.https.CallableContext) => {
    const userUid = context.auth?.uid;
    const user = await getEntityByRef<User>(
      userUid === undefined ? undefined : admin.firestore().collection(`${usersCollection}`).doc(userUid),
    );
    if (userUid === undefined || user === undefined) {
      return new functions.https.HttpsError('unauthenticated', 'Request is unauthenticated');
    }

    const stripe = createStripeClient();

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

    // order type/shipment

    const orderType = await getOrderTypeByCode(data.deliveryType);

    if (orderType === undefined) {
      return new functions.https.HttpsError('failed-precondition', 'No such order type exists.');
    }

    const orderTypeLineItem =
      orderType.shipping_fee_eur_no_vat === 0
        ? []
        : [
            {
              price_data: {
                currency: 'eur',
                product_data: {
                  name: (() => {
                    switch (user.preferred_language) {
                      case 'sk':
                        return orderType.localized_name.sk;
                      default:
                        return orderType.code;
                    }
                  })(),
                  images: [],
                },
                unit_amount: Math.round(calculateOrderTypeFinalPrice(orderType) * 100),
              },
              quantity: 1,
            },
          ];

    // Promos check

    const promoCodes = await (async () => {
      if (data.promoCode !== undefined) {
        const promo = await getPromoByCode(data.promoCode);
        if (promo === undefined) {
          return undefined;
        }

        if (!isPromoValid(promo, cart)) {
          return undefined;
        }

        const coupon = await stripe.coupons.create({
          name: `Promo: ${data.promoCode}`,
          amount_off: Math.round(promo.discount_value * 100),
          currency: 'eur',
        });

        return [{ coupon: coupon.id }];
      }

      return [];
    })();

    if (promoCodes === undefined) {
      return new functions.https.HttpsError(
        'failed-precondition',
        'Promo code either does not exist, or the cart has not met preconditions.',
      );
    }

    const orderId = await generateNewOrderId();
    const metadata: StripePaymentMetadata = {
      userId: userUid,
      orderId,
      platform: data.platform,
      deliveryType: data.deliveryType,
      orderNote: data.orderNote.trim() === '' ? data.orderNote.trim() : undefined,
    };

    // stripe.coupons.;
    const session = await stripe.checkout.sessions.create({
      payment_method_types: ['card'],
      line_items: productLineItems.concat(orderTypeLineItem),
      metadata: metadata as unknown as Stripe.MetadataParam,
      mode: 'payment',
      success_url: data.successUrl,
      cancel_url: data.cancelUrl,
      discounts: promoCodes,
    });

    return session.id;
  });
