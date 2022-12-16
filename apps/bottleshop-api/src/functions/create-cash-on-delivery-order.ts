import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

import {
  createOrder,
  deleteCartItems,
  updateProductStockCounts,
  updatePromoCodeUses,
} from './on-payment-status-update';
import { DeliveryType } from '../models/order-type';
import { PaymentData } from '../models/payment-data';
import { tier1Region } from '../constants/other';
import { generateNewOrderId } from '../utils/order-utils';

export const createCashOnDeliveryOrder = functions
  .region(tier1Region)
  .runWith({ allowInvalidAppCheckToken: true })
  .https.onCall(async (data: PaymentData, context: functions.https.CallableContext) => {
    functions.logger.log('handler for createCashOnDeliveryOrder invoked');
    try {
      const userUid = context.auth?.uid;

      if (userUid === undefined) {
        return new functions.https.HttpsError('unauthenticated', 'Request is unauthenticated');
      }

      const orderId = await generateNewOrderId();
      const { deliveryType, orderNote } = data;
      if (orderId) {
        functions.logger.log(`createCashOnDeliveryOrder: ${userUid} ${deliveryType} ${orderNote} ${orderId}`);
        const oId = await admin.firestore().runTransaction<string | undefined>(async () => {
          const result = await createOrder(
            userUid,
            deliveryType as DeliveryType,
            parseInt(orderId, 10),
            orderNote,
            undefined,
          );
          if (result === undefined) {
            return undefined;
          }
          const [orderDoc, cart] = result;

          // First update stock counts and promo counts and after that delete cart items
          await Promise.all([updateProductStockCounts(userUid), updatePromoCodeUses(cart.promo_code || undefined)]);
          await deleteCartItems(userUid);

          return orderDoc;
        });
        functions.logger.log(`createCashOnDeliveryOrder ${oId}`);

        if (oId) {
          return { orderId };
        }
      }
    } catch (e) {
      functions.logger.error(`payment failed ${e}`);
      return e;
    }
  });
