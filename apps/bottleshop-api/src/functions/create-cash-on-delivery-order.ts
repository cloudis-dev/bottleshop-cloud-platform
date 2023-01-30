import * as functions from 'firebase-functions';

import { PaymentData } from '../models/payment-data';
import { tier1Region } from '../constants/other';
import { createOrderEffect, generateNewOrderId, getOrderTypeByCode } from '../utils/order-utils';
import { getPromoByCode, isPromoValidV2 } from '../utils/promo-code-utils';
import { getCartItems, getCartTotalPriceV2 } from '../utils/cart-utils';

export const createCashOnDeliveryOrder = functions
  .region(tier1Region)
  .runWith({ allowInvalidAppCheckToken: true })
  .https.onCall(async (data: PaymentData, context: functions.https.CallableContext) => {
    functions.logger.info(`Create cash-on-delivery order. PaymentData:  ${JSON.stringify(data)}`);

    try {
      const userUid = context.auth?.uid;

      if (userUid === undefined) {
        return new functions.https.HttpsError('unauthenticated', 'Request is unauthenticated');
      }

      const orderId = await generateNewOrderId();

      const orderType = (await getOrderTypeByCode(data.deliveryType))?.[0];
      if (orderType === undefined) {
        return new functions.https.HttpsError('failed-precondition', 'No such order type exists.');
      }
      if (orderType.code !== 'cash-on-delivery') {
        return new functions.https.HttpsError('failed-precondition', 'Order type has to be cash-on-delivery.');
      }

      let promo = undefined;
      if (data.promoCode !== undefined) {
        promo = (await getPromoByCode(data.promoCode))?.[0];
        const cartItems = await getCartItems(userUid);
        if (promo === undefined || !isPromoValidV2(promo, orderType, cartItems)) {
          return new functions.https.HttpsError(
            'failed-precondition',
            'Promo code either doesnt exist or is not valid for the cart.',
          );
        }
      }

      const total2Pay = await getCartTotalPriceV2(userUid, orderType, promo);

      const orderDocId = await createOrderEffect(
        userUid,
        orderType.code,
        parseInt(orderId, 10),
        data.orderNote,
        promo === undefined ? undefined : { code: promo.code, discountValue: promo.discount_value },
        total2Pay,
      );

      functions.logger.log(`createCashOnDeliveryOrder success. Order document id: ${orderDocId}`);
      return orderDocId;
    } catch (e) {
      functions.logger.error(`payment failed ${e}`);
      return new functions.https.HttpsError('internal', JSON.stringify(e));
    }
  });
