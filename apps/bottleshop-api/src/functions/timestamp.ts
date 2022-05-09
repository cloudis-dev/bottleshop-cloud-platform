import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { tier1Region } from '../constants/other';

export const getCurrentTimestamp = functions
  .region(tier1Region)
  .runWith({ memory: '128MB' })
  .https.onCall(() => admin.firestore.Timestamp.now());
