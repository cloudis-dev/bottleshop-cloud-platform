import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

import {
  createNotification,
  getCustomerDeviceTokens,
} from '../../../utils/notification-utils';
import { CustomerOrderNotification } from '../../../models/notification-models';
import { getEntityByRef } from '../../../utils/document-reference-utils';
import { getStatusStepNotificationTitle } from '../../../utils/order-utils';
import { isEmulator } from '../../../utils/functions-utils';
import { Order } from '../../../models/order';
import { OrderType } from '../../../models/order-type';
import { usersCollection } from '../../../constants/collections';

export const onOrderCreatedCustomerNotification = async (orderSnapshot: functions.firestore.DocumentSnapshot) => {
  const order = orderSnapshot.data() as Order;

  if (isEmulator()) {
    functions.logger.log(`Sending order created customer notification. Order: ${JSON.stringify(order)}`);
    return;
  }

  const [deviceTokens, orderType] = await Promise.all([
    getCustomerDeviceTokens(admin.firestore().collection(usersCollection).doc(order.customer.uid)),
    getEntityByRef<OrderType>(order.order_type_ref),
  ]);

  if (orderType == null) {
    functions.logger.error(`Could not get OrderType entity by reference: ${order.order_type_ref}`);
    return;
  }

  const lang = order.customer.preferred_language ?? 'sk';

  const title = getStatusStepNotificationTitle(0, order, orderType.code, lang);
  if (title == null) {
    functions.logger.error('Could not get notification title.');
    return;
  }

  const notification = createNotification<CustomerOrderNotification>({
    title,
    body:
      lang === 'sk'
        ? `Detaily boli odoslané na nasledujúcu e-mailovú adresu: ${order.customer.email}`
        : `Detailed information was sent to the following email address: ${order.customer.email}`,
    payload: {
      order_id: order.id.toString(),
      document_id: orderSnapshot.id,
    },
  });

  if (deviceTokens.length > 0 && deviceTokens.every((val) => val.length > 0)) {
    await admin.messaging().sendToDevice(deviceTokens, notification);
  }
};
