import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

import { tier1Region } from '../constants/other';
import { usersCollection } from '../constants/collections';

export const deleteAccount = functions
  .region(tier1Region)
  .runWith({ memory: '512MB' })
  .https.onCall(async (_, context) => {
    if (context.app === undefined) {
      throw new functions.https.HttpsError(
        'failed-precondition',
        'The function must be called from an App Check verified app.',
      );
    }
    const userUid = context.auth?.uid;
    if (userUid === undefined) {
      return { success: false, error: 'Authentication Required!' };
    }

    const isError = await admin
      .auth()
      .deleteUser(userUid)
      .then(async () => {
        functions.logger.log(`Successfully deleted user with uid: ${userUid}.`);

        const userDoc = admin.firestore().collection(`${usersCollection}`).doc(userUid);
        try {
          await admin.firestore().recursiveDelete(userDoc);
          functions.logger.log(`Successfully deleted user's (uid: ${userUid}) db record.`);
          return false;
        } catch (error) {
          functions.logger.error(`Failed to delete user's (uid: ${userUid}) db record. Error: ${error}`);
          return true;
        }
      })
      .catch((error) => {
        functions.logger.error(`Failed to delete user with uid: ${userUid}. Error: ${error}.`);

        return true;
      });

    return { success: isError ? false : true };
  });
