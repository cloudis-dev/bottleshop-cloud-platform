import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import { getEntityByRef } from '../../../utils/document-reference-utils';
import { mailCollection } from '../../../constants/collections';
import { Order } from '../../../models/order';
import { OrderType } from '../../../models/order-type';

import { isEmulator, isTestEnv } from '../../../utils/functions-utils';
import { createMail, getManagementEmails, getOrderDetailsForMail } from '../../../utils/mail-utils';

/**
 * Send mail to management about the new order.
 * @returns
 * @param orderSnapshot
 */
export const onOrderCreatedAdminMail = async (orderSnapshot: functions.firestore.DocumentSnapshot) => {
  const order = orderSnapshot.data() as Order;
  const [orderType, managementEmails] = await Promise.all([
    getEntityByRef<OrderType>(order.order_type_ref),
    getManagementEmails(),
  ]);

  if (orderType === undefined) {
    functions.logger.error(`Could not get OrderType entity by reference: ${order.order_type_ref.id}`);
    return;
  }

  const body = getOrderDetailsForMail(order, orderType, 'sk');
  const subject = `Bottleshop ADMIN: Nová objednavka ${order.id}`;

  if (isEmulator() || isTestEnv()) {
    functions.logger.log(
      `Sending order created mail to management.
      Mails: ${managementEmails}
      Subject: ${subject}
      Body: ${body}`,
    );
    return;
  }

  await Promise.all(
    managementEmails.map((email) => admin.firestore().collection(mailCollection).add(createMail(email, subject, body))),
  )
    .then(() => functions.logger.log(`Email with the created order (id: ${order.id}) sent to management.`))
    .catch(() =>
      functions.logger.error(`Failed to send an email with the created order (id: ${order.id}) to management.`),
    );
};
