import * as admin from 'firebase-admin';

import { devicesSubCollection } from '../constants/collections';

/**
 * Create notification with the flutter click action.
 * The `action_tag` parameter is used to distinguish types of notifications on the client.
 * e.g. new order notification, out of stock notification, etc.
 *
 * @param args
 * @returns
 */
export function createNotification<T>(args: {
  title: string;
  body: string;
  action_tag?: string;
  payload: T;
}): admin.messaging.MessagingPayload {
  return {
    notification: {
      title: args.title,
      body: args.body,
    },
    data: {
      title: args.title,
      body: args.body,
      action_tag: args.action_tag ?? '',
      ...args.payload,
    },
  };
}

export async function getCustomerDeviceTokens(customerRef: FirebaseFirestore.DocumentReference): Promise<string[]> {
  const snap = await customerRef.collection(devicesSubCollection).get();
  return snap.docs.map((e) => e.get('token')).filter((e) => e != null);
}
