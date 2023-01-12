import { config } from 'firebase-functions';
import * as functions from 'firebase-functions';

import { acquireCategoriesIndex, createClient, objectIdAlgoliaFieldName } from '../utils/algolia-utils';
import { categoriesCollection } from '../constants/collections';
import { categoryFields } from '../constants/model-constants';
import { DocumentChange, getDocumentChange } from '../utils/document-snapshot-utils';
import { isEmulator, isTestEnv } from '../utils/functions-utils';
import { tier1Region } from '../constants/other';

/**
 * Updating algolia categories index.
 */
export const onCategoryWriteAlgoliaUpdate = functions
  .region(tier1Region)
  .firestore.document(`${categoriesCollection}/{category}`)
  .onWrite(async (snap) => {
    if (isEmulator() || isTestEnv()) {
      return;
    }

    const client = createClient({
      algoliaAdminKey: config().algolia.apikey,
    });
    const categoriesIndex = acquireCategoriesIndex(client);

    if (getDocumentChange(snap) === DocumentChange.deleted) {
      await categoriesIndex.deleteObject(snap.before.id);
    } else {
      const data = snap.after.data();
      if (!data) {
        functions.logger.error('Couldnt update algolia categories index');
        return;
      }

      delete data[categoryFields.subcategoriesRefs];
      data[categoryFields.uid] = snap.after.id;
      data[objectIdAlgoliaFieldName] = snap.after.id;

      categoriesIndex
        .saveObject(data)
        .then((val) => functions.logger.log(val))
        .catch((err) => functions.logger.error(err));
    }
  });
