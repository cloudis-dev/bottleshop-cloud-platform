import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

import {
  createOrder,
  deleteCartItems,
  updateProductStockCounts,
  updatePromoCodeUses,
} from './on-payment-status-update';
import { DeliveryType } from '../models/order-type';
import { generateNewOrderId } from './create-payment-intent';
import { PaymentData } from '../models/payment-data';
import { tier1Region } from '../constants/other';

export const createCashOnDeliveryOrder = functions
  .region(tier1Region)
  .https.onCall(async (data: PaymentData, context: functions.https.CallableContext) => {
    functions.logger.log('handler for createCashOnDeliveryOrder invoked');
    if (context.app == undefined) {
      throw new functions.https.HttpsError(
        'failed-precondition',
        'The function must be called from an App Check verified app.',
      );
    }
    try {
      if (context.auth && context.auth.uid) {
        const orderId = await generateNewOrderId();
        const { userId, deliveryType, orderNote } = data;
        if (userId && orderId) {
          functions.logger.log(`createCashOnDeliveryOrder: ${userId} ${deliveryType} ${orderNote} ${orderId}`);
          const oId = await admin.firestore().runTransaction<string | undefined>(async () => {
            const result = await createOrder(userId, deliveryType as DeliveryType, parseInt(orderId, 10), orderNote);
            if (result == null) {
              return undefined;
            }
            const [orderDoc, cart] = result;

            // First update stock counts and promo counts and after that delete cart items
            await Promise.all([updateProductStockCounts(userId), updatePromoCodeUses(cart.promo_code || undefined)]);
            await deleteCartItems(userId);

            return orderDoc;
          });
          functions.logger.log(`createCashOnDeliveryOrder ${oId}`);

          if (oId) {
            return { orderId };
          }
        }
      }
    } catch (e) {
      functions.logger.error(`payment failed ${e}`);
      return e;
    }
  });
