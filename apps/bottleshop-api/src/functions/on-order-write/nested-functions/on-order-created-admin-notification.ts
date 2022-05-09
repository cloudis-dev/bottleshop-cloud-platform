import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

import { AdminNewOrderNotification } from '../../../models/notification-models';
import {
  adminNewOrderNotificationTag,
  adminNotificationTopic,
} from '../../../constants/notification-constants';
import { createNotification } from '../../../utils/notification-utils';
import { isEmulator } from '../../../utils/functions-utils';
import { Order } from '../../../models/order';

/**
 * Send notification to admins that a new order has been created.
 * @param orderSnapshot
 * @returns
 */
export const onOrderCreatedAdminNotification = async (orderSnapshot: functions.firestore.DocumentSnapshot) => {
  const data = orderSnapshot.data() as Order;

  const notification = createNotification<AdminNewOrderNotification>({
    title: 'Nová objednávka',
    body: `Objednávka s ID ${data.id}.`,
    action_tag: adminNewOrderNotificationTag,
    payload: {
      new_order_uid: orderSnapshot.id,
    },
  });

  if (isEmulator()) {
    functions.logger.log(
      `Sending order created notification to admins.
      Topic: ${adminNotificationTopic}
      Notification: ${notification}`,
    );
    return;
  }

  return admin.messaging().sendToTopic(adminNotificationTopic, notification);
};
