import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import { mailCollection } from '../constants/collections';

import { tier1Region } from '../constants/other';
import { createMail } from '../utils/mail-utils';

export const postFeedback = functions
  .region(tier1Region)
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  .https.onCall(async (dataMail: {to :string, text :string, html:string, subject: string, path: {path:string}[]}, context) => {
    if (context.auth === null) {
      functions.logger.error('auth error');
      return new functions.https.HttpsError('unauthenticated', 'Request is unauthenticated'); 
    }
  
    const expression = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/i;
    if(!expression.test(dataMail.to) || dataMail.subject.length < 1 || 75 < dataMail.subject.length || dataMail.text.length < 1 || 300 < dataMail.text.length || dataMail.to.length < 1 || 50 < dataMail.to.length || dataMail.html.length < 1 || 300 < dataMail.html.length){
      functions.logger.error('Validation error');
      return new functions.https.HttpsError('invalid-argument', 'Request is unvalidated'); 
    }
    if(dataMail.path.length>3){
      functions.logger.error('too many files');
      return new functions.https.HttpsError('invalid-argument', 'Request has too many files'); 
    }
    await admin.firestore().collection(mailCollection).add(createMail(dataMail.to,dataMail.subject , dataMail.text, dataMail.html,dataMail.path))
    return { success: true };
  });
