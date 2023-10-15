import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import { tier1Region } from '../constants/other';

export const getCurrentTimestamp = functions
  .region(tier1Region)
  .runWith({ memory: '128MB', enforceAppCheck: false })
  .https.onCall(() => admin.firestore.Timestamp.now());
