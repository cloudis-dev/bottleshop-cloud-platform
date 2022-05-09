import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

import { adminUsersCollection } from '../constants/collections';
import { tier1Region } from '../constants/other';

/**
 * Trigger on admin user create - sets admin user claims. (admin: true)
 */
export const onAdminUserCreate = functions
  .region(tier1Region)
  .firestore.document(`${adminUsersCollection}/{userId}`)
  .onCreate(async (snap, context) => {
    const userId: string = context.params.userId;
    const claims = {
      admin: true,
    };

    await admin.auth().setCustomUserClaims(userId, claims);
  });

/**
 * Trigger on admin user delete - removes admin user claims.
 */
export const onAdminUserDelete = functions
  .region(tier1Region)
  .firestore.document(`${adminUsersCollection}/{userId}`)
  .onDelete(async (snap, context) => {
    const userId: string = context.params.userId;

    return admin
      .auth()
      .setCustomUserClaims(userId, {})
      .then(() => functions.logger.log(`User: ${userId} admin claims removed.`))
      .catch((err) => functions.logger.error(`User: ${userId} admin claims couldn't be removed. Error: ${err}`));
  });
