import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

import { tier1Region } from '../constants/other';
import { usersCollection } from '../constants/collections';

export const deleteAccount = functions
  .region(tier1Region)
  .runWith({ memory: '512MB' })
  .https.onCall(async (_, context) => {
    if (context.auth == null) {
      return { success: false, error: 'Authentication Required!' };
    }

    const userUid = context.auth.uid;

    let isError = false;

    await admin
      .auth()
      .deleteUser(userUid)
      .then(() => {
        functions.logger.log(`Successfully deleted user with uid: ${userUid}.`);

        const userDoc = admin.firestore().collection(`${usersCollection}`).doc(userUid);

        admin
          .firestore()
          .recursiveDelete(userDoc)
          .then(() => {
            functions.logger.log(`Successfully deleted user's (uid: ${userUid}) db record.`);
          })
          .catch((error: Error) => {
            functions.logger.error(`Failed to delete user's (uid: ${userUid}) db record. Error: ${error}`);
            isError = true;
          });
      })
      .catch((error) => {
        functions.logger.error(`Failed to delete user with uid: ${userUid}. Error: ${error}.`);

        isError = true;
      });

    return { success: isError ? false : true };
  });
