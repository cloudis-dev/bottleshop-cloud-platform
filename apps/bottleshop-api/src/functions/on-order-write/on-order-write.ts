import * as functions from 'firebase-functions';

import { DocumentChange } from '../../models/document-change';
import {
  getDocumentChange,
  hasFieldChanged,
} from '../../utils/document-snapshot-utils';
import { onOrderCreatedAdminMail } from './nested-functions/on-order-created-admin-mail';
import { onOrderCreatedAdminNotification } from './nested-functions/on-order-created-admin-notification';
import { onOrderCreatedCustomerMail } from './nested-functions/on-order-created-customer-mail';
import { onOrderCreatedCustomerNotification } from './nested-functions/on-order-created-customer-notification';
import { onOrderStatusChangeCustomerMails } from './nested-functions/on-order-status-change-customer-mails';
import {
  onOrderStatusChangeCustomerNotification,
} from './nested-functions/on-order-status-change-customer-notifications';
import { onOrderStatusChangeManagementMails } from './nested-functions/on-order-status-change-management-mails';
import { orderFields } from '../../constants/model-constants';
import { ordersCollection } from '../../constants/collections';
import { tier1Region } from '../../constants/other';

export const onOrderWrite = functions
  .region(tier1Region)
  .firestore.document(`${ordersCollection}/{order}`)
  .onWrite(async (snap) => {
    switch (getDocumentChange(snap)) {
      case DocumentChange.created:
        await Promise.all([
          onOrderCreatedAdminNotification(snap.after),
          onOrderCreatedAdminMail(snap.after),
          onOrderCreatedCustomerMail(snap.after),
          onOrderCreatedCustomerNotification(snap.after),
        ]);
        break;
      case DocumentChange.updated:
        if (hasFieldChanged(orderFields.statusStepId, snap)) {
          await Promise.all([
            onOrderStatusChangeCustomerNotification(snap.after),
            onOrderStatusChangeCustomerMails(snap.after),
            onOrderStatusChangeManagementMails(snap.after),
          ]);
        }
        break;
    }
  });
