import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import { mailCollection } from '../constants/collections';

import { tier1Region } from '../constants/other';
import { createMail, getManagementEmails } from '../utils/mail-utils';

export const postFeedback = functions
  .region(tier1Region)
  .runWith({ allowInvalidAppCheckToken: true })
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  .https.onCall(async (DT: {to :string, text :string, html:string, subject: string, path: {path:string}[]}, context) => {
    const managementEmails = await Promise.all([
      getManagementEmails(),
    ]);
    if (context.auth === null) {
      functions.logger.error('auth error');
      return;
    }
    const expression = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/i;
    if(!expression.test(DT.to) || DT.subject.length < 1 || DT.subject.length > 75 || DT.text.length < 1 || DT.text.length > 300 || DT.to.length < 1 || DT.to.length > 50 || DT.html.length < 1 || DT.html.length > 300){
      functions.logger.error('Validation error');
      return;
    }
    if(DT.path.length>3){
      functions.logger.error('too many files');
      return;
    }
    functions.logger.error(DT.to);
    managementEmails.map((email) => admin.firestore().collection(mailCollection).add(createMail(DT.to,DT.subject , DT.text, DT.html,DT.path)))
  });
