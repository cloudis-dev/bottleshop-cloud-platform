import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

import { createMail } from '../../../utils/mail-utils';
import { getEntityByRef } from '../../../utils/document-reference-utils';
import { getMailBodyHtml } from '../../../utils/order-utils';
import { isEmulator, isTestEnv } from '../../../utils/functions-utils';
import { Language } from '../../../constants/other';
import { mailCollection } from '../../../constants/collections';
import { Order } from '../../../models/order';
import { OrderType } from '../../../models/order-type';

/**
 * Send mail to customer that the order has been created.
 * @returns
 * @param orderSnapshot
 */
export const onOrderCreatedCustomerMail = async (orderSnapshot: functions.firestore.DocumentSnapshot) => {
  const order = orderSnapshot.data() as Order;
  const orderType = await getEntityByRef<OrderType>(order.order_type_ref);

  if (!orderType) {
    functions.logger.error(`Could not get OrderType entity by reference: ${order.order_type_ref}`);
    return;
  }

  if (!order.customer.email) {
    functions.logger.error(`User doesn't have email: ${order.customer}`);
    return;
  }

  const lang: Language = order.customer.preferred_language ?? 'sk';
  const html = await getMailBodyHtml(order.status_step_id, order, orderType, order.customer, lang);

  const mail = createMail(
    order.customer.email,
    `Bottleshop Tri Veže: ${lang === 'sk' ? 'Prijatie objednávky' : 'Order acceptance'} - ${order.id}`,
    '',
    html,
  );

  if (isEmulator() || isTestEnv()) {
    functions.logger.log(`Sending order created mail to customer. Mail: ${JSON.stringify(mail)}`);
    return;
  }

  return admin
    .firestore()
    .collection(mailCollection)
    .add(mail)
    .then(() =>
      functions.logger.log(
        `Email with the created order (id: ${order.id}) sent to a customer: ${order.customer.email}.`,
      ),
    )
    .catch(() =>
      functions.logger.error(
        `Failed to send an email with the created order (id: ${order.id}) to a customer: ${order.customer.email}.`,
      ),
    );
};
