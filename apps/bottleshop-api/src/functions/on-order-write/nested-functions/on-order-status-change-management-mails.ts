import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

import {
  createMail,
  getManagementEmails,
  getOrderDetailsForMail,
} from '../../../utils/mail-utils';
import { getEntityByRef } from '../../../utils/document-reference-utils';
import { isEmulator } from '../../../utils/functions-utils';
import { mailCollection } from '../../../constants/collections';
import { Order } from '../../../models/order';
import { OrderType } from '../../../models/order-type';

export const onOrderStatusChangeManagementMails = async (orderSnapshot: functions.firestore.DocumentSnapshot) => {
  const order = orderSnapshot.data() as Order;
  const orderType = await getEntityByRef<OrderType>(order.order_type_ref);

  if (order.status_step_id !== 3 || orderType == null) {
    return;
  }

  if (isEmulator()) {
    functions.logger.log(`Sending order completed mails management. Order: ${JSON.stringify(order)}`);
    return;
  }

  const managementEmails = await getManagementEmails();

  await Promise.all(
    managementEmails
      .map((email) =>
        createMail(
          email,
          `Bottleshop ADMIN: Objednávka ${order.id} vybavená`,
          getOrderDetailsForMail(order, orderType, 'sk'),
        ),
      )
      .map((mail) => admin.firestore().collection(mailCollection).add(mail)),
  );
};
