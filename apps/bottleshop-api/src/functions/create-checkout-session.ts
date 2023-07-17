import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import Stripe from 'stripe';
import { tier1Region } from '../constants/other';
import { usersCollection } from '../constants/collections';
import { getEntityByRef } from '../utils/document-reference-utils';
import { areProductsAvailableForPurchase, getCartItems } from '../utils/cart-utils';
import { calculateProductFinalPrice, getProductImageUrl } from '../utils/product-utils';
import { PaymentData, StripePaymentMetadata } from '../models/payment-data';
import { createStripeClient } from '..';
import { calculateOrderTypeFinalPrice, generateNewOrderId, getOrderTypeByCode } from '../utils/order-utils';
import { getPromoByCode, isPromoValidV2 } from '../utils/promo-code-utils';
import { User } from '../models/user';
import { PromoCode } from '../models/promo-code';

export const createCheckoutSession = functions
  .region(tier1Region)
  .runWith({ enforceAppCheck: false })
  .https.onCall(async (data: PaymentData, context: functions.https.CallableContext) => {
    functions.logger.info(`Create checkout session. PaymentData:  ${JSON.stringify(data)}`);

    const userUid = context.auth?.uid;
    const user = await getEntityByRef<User>(
      userUid === undefined ? undefined : admin.firestore().collection(`${usersCollection}`).doc(userUid),
    );
    if (userUid === undefined || user === undefined) {
      return new functions.https.HttpsError('unauthenticated', 'Request is unauthenticated');
    }

    const stripe = createStripeClient();

    // Cart check

    const cartItems = await getCartItems(userUid);

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

    const orderType = (await getOrderTypeByCode(data.deliveryType))?.[0];

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
                        return orderType.name;
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

    let promoRes: [{ coupon: string }, PromoCode] | undefined = undefined;
    let discountValue: number | undefined = undefined;
    if (data.promoCode !== undefined) {
      const promo = (await getPromoByCode(data.promoCode))?.[0];
      if (promo === undefined || !isPromoValidV2(promo, orderType, cartItems)) {
        return new functions.https.HttpsError(
          'failed-precondition',
          'Promo code either doesnt exist or is not valid for the cart.',
        );
      }
      const totalSum = cartItems
        .map((item) => item.quantity * calculateProductFinalPrice(item.product))
        .reduce((acc, a) => a + acc);
      discountValue =
        promo.promo_code_type == 'percent'
          ? (promo.discount_value / 100) * totalSum
          : Math.round(promo.discount_value * 100);

      const stripeCoupon = await stripe.coupons.create({
        name: `Promo: ${data.promoCode}`,
        amount_off: discountValue,
        currency: 'eur',
      });

      promoRes = [{ coupon: stripeCoupon.id }, promo];
    }

    const [stripeDiscount, promoCode] = [promoRes?.[0], promoRes?.[1]];

    const orderId = await generateNewOrderId();
    const metadata: StripePaymentMetadata = {
      userId: userUid,
      orderId,
      platform: data.platform,
      deliveryType: data.deliveryType,
      orderNote: data.orderNote.trim() === '' ? data.orderNote.trim() : undefined,
      promoCode: promoCode?.code,
      promoDiscountValue: discountValue,
    };

    const session = await stripe.checkout.sessions.create({
      payment_method_types: ['card'],
      customer_email: user.email,
      line_items: productLineItems.concat(orderTypeLineItem),
      metadata: metadata as unknown as Stripe.MetadataParam,
      mode: 'payment',
      success_url: data.successUrl,
      cancel_url: data.cancelUrl,
      discounts: stripeDiscount === undefined ? undefined : [stripeDiscount],
      locale: data.locale === 'sk' ? 'sk' : 'en',
    });

    return session.id;
  });
