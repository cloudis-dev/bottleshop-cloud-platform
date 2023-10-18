import * as functions from 'firebase-functions';
import { algoliaApiKey } from '../../../environment';
import { Product } from '../../../models/product';
import { productFields } from '../../../constants/model-constants';

import { acquireProductsIndex, createClient, firebase2AlgoliaObjMappingFn } from '../../../utils/algolia-utils';
import { DocumentChange, getDocumentChange } from '../../../utils/document-snapshot-utils';
import { isEmulator, isTestEnv } from '../../../utils/functions-utils';

/**
 * Update and sync the algolia products with the firestore.
 * @param snap
 */
export const onUpdateAlgolia = async (snap: functions.Change<functions.firestore.DocumentSnapshot>) => {
  functions.logger.info('Updating algolia');

  if (isEmulator() || isTestEnv()) {
    return;
  }

  const client = createClient({
    algoliaAdminKey: algoliaApiKey.value(),
  });
  const productsIndex = acquireProductsIndex(client);

  if (getDocumentChange(snap) === DocumentChange.deleted) {
    productsIndex
      .deleteObject(snap.before.get(productFields.cmatField))
      .then((val: unknown) => functions.logger.log(val))
      .catch((err: unknown) => functions.logger.error(err));
  }
  // created or updated
  else {
    const product = snap.after.data() as Product;

    productsIndex
      .saveObject(firebase2AlgoliaObjMappingFn(product))
      .then((val: unknown) => functions.logger.log(val))
      .catch((err: unknown) => functions.logger.error(err));
  }
};
