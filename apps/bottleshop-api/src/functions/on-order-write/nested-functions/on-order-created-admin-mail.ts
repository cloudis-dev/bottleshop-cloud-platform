import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

import { createMail, getManagementEmails, getOrderDetailsForMail } from '../../../utils/mail-utils';
import { getEntityByRef } from '../../../utils/document-reference-utils';
import { isEmulator, isTestEnv } from '../../../utils/functions-utils';
import { mailCollection } from '../../../constants/collections';
import { Order } from '../../../models/order';
import { OrderType } from '../../../models/order-type';

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
    functions.logger.error(`Could not get OrderType entity by reference: ${order.order_type_ref}`);
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
    //return;
  }
  const addMailPromises = managementEmails.map(async (mail) => {
    await addMail(mail, subject, body);
  });
  await Promise.all(addMailPromises);
  functions.logger.log(managementEmails.length);
};

const addMail = async (email: string, subject: string, body:string) => {
      await admin.firestore().collection(mailCollection).add(createMail(email, subject, body));
}
