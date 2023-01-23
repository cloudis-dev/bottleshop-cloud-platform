import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

import { createMail } from '../../../utils/mail-utils';
import { getEntityByRef } from '../../../utils/document-reference-utils';
import { getMailBodyHtml, getMailSubject } from '../../../utils/order-utils';
import { isEmulator } from '../../../utils/functions-utils';
import { mailCollection } from '../../../constants/collections';
import { Order } from '../../../models/order';
import { OrderType } from '../../../models/order-type';

export const onOrderStatusChangeCustomerMails = async (orderSnapshot: functions.firestore.DocumentSnapshot) => {
  const order = orderSnapshot.data() as Order;

  if (isEmulator()) {
    functions.logger.log(`Sending order status change customer mail. Order: ${JSON.stringify(order)}`);
    return;
  }

  const orderType = await getEntityByRef<OrderType>(order.order_type_ref);

  if (orderType === undefined) {
    functions.logger.error(
      `Failed to send order status update emails. Reason: Order status for the order ${order.id} does not exist!`,
    );
    return;
  }

  const subject = getMailSubject(order.status_step_id, order, orderType, order.customer.preferred_language ?? 'sk');
  const html = await getMailBodyHtml(
    order.status_step_id,
    order,
    orderType,
    order.customer,
    order.customer.preferred_language ?? 'sk',
  );

  if (subject !== undefined && html !== undefined && order.customer.email !== undefined) {
    const mail = createMail(order.customer.email, subject, '', html);

    await admin.firestore().collection(mailCollection).add(mail);
  } else {
    functions.logger.warn(`Didn't send email to customer for order status change. Order: ${JSON.stringify(order)}`);
  }
};
