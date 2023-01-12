import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

import {
  adminNotificationTopic,
  adminProductOutOfStockNotificationTag,
} from '../../../constants/notification-constants';
import { AdminOutOfStockNotification } from '../../../models/notification-models';
import { createMail, getManagementEmails } from '../../../utils/mail-utils';
import { createNotification } from '../../../utils/notification-utils';
import { isEmulator, isTestEnv } from '../../../utils/functions-utils';
import { mailCollection } from '../../../constants/collections';
import { Product } from '../../../models/product';

export const onQuantityUpdated = async (productSnapshot: functions.firestore.DocumentSnapshot) => {
  const product = productSnapshot.data() as Product;

  if (product.amount === 0) {
    await Promise.all([sendOutOfStockManagementMails(product), sendOutOfStockAdminNotification(product)]);
  }
};

/**
 * Send notifications for admins that the product is out of stock.
 * @param product
 * @returns
 */
async function sendOutOfStockAdminNotification(product: Product): Promise<void> {
  const notification = createNotification<AdminOutOfStockNotification>({
    title: `Položka CMAT: ${product.cmat} nie je na sklade`,
    body: product.name,
    action_tag: adminProductOutOfStockNotificationTag,
    payload: {
      product_uid: product.cmat,
    },
  });

  if (isEmulator()) {
    functions.logger.log(`Sending out of stock admin notifications. Notification: ${JSON.stringify(notification)}`);
    return;
  }

  return admin
    .messaging()
    .sendToTopic(adminNotificationTopic, notification)
    .then(() => functions.logger.log(`Product out of stock admin notifications sent. CMAT: ${product.cmat}`));
}

/**
 * Send mails for management that the product is out of stock
 * @param product
 * @returns
 */
async function sendOutOfStockManagementMails(product: Product): Promise<void> {
  const managementMails = await getManagementEmails();

  const subject = `Bottleshop ADMIN: Položka ${product.name} nie je na sklade`;
  const body = `Položka ${product.name} nie je na sklade. CMAT: ${product.cmat}`;

  if (isEmulator() || isTestEnv()) {
    functions.logger.log(`Sending out of stock management mails.
    The mails: ${managementMails}
    Mail subject: ${subject}
    Mail body: ${body}`);
    return;
  }

  await Promise.all(
    managementMails.map((email) => admin.firestore().collection(mailCollection).add(createMail(email, subject, body))),
  )
    .then(() =>
      functions.logger.log(`Out of stock mail notification sent to management emails (product cmat: ${product.cmat}).`),
    )
    .catch(() =>
      functions.logger.error(
        `Out of stock mail notification failed to be sent to some management emails (product cmat: ${product.cmat}).`,
      ),
    );
}
