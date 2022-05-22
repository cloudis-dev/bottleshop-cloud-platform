import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

import { tier1Region } from '../constants/other';

export const getCurrentTimestamp = functions
  .region(tier1Region)
  .runWith({ memory: '128MB' })
  .https.onCall((data: unknown, context: functions.https.CallableContext) => {
    if (context.app == undefined) {
      throw new functions.https.HttpsError(
        'failed-precondition',
        'The function must be called from an App Check verified app.',
      );
    }
    return admin.firestore.Timestamp.now();
  });
