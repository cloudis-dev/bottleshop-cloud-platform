import * as functions from 'firebase-functions';

import { tier1Region } from '../constants/other';

export const postFeedback = functions
  .region(tier1Region)
  .runWith({ allowInvalidAppCheckToken: true })
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  .https.onCall(async (_, context) => {
    functions.logger.error('hello from post feedback');
  });
