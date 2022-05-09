import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import removeAccents = require('remove-accents');

import { hasFieldChanged } from '../../../utils/document-snapshot-utils';
import { productFields } from '../../../constants/model-constants';
import { productsCollection } from '../../../constants/collections';
import { VAT } from '../../../constants/other';

/**
 * Update sort fields on product and update the product document.
 * @param snap
 */
export const onUpdateSortFields = async (snap: functions.Change<functions.firestore.DocumentSnapshot>) => {
  // When not deleted
  if (snap.after.exists) {
    const data = snap.after.data()!;
    const resultUpdateObj: any = {};

    // When discount or priceNoVat is not equal to previous version
    const shouldChangeFinalPrice =
      snap.before.exists &&
      (hasFieldChanged(productFields.discountField, snap) || hasFieldChanged(productFields.priceNoVatField, snap));

    // When final price is not yet in the document or when changed
    if (!(productFields.finalPriceField in data) || shouldChangeFinalPrice) {
      const discountMultiplier = data[productFields.discountField] ?? 0;

      resultUpdateObj[productFields.finalPriceField] =
        (1 + VAT) * data[productFields.priceNoVatField] * (1 - discountMultiplier);
    }

    const shouldUpdateNameSortField = snap.before.exists && hasFieldChanged(productFields.nameField, snap);

    if (!(productFields.nameSortField in data) || shouldUpdateNameSortField) {
      resultUpdateObj[productFields.nameSortField] = removeAccents(data[productFields.nameField]).toLowerCase();
    }

    if (Object.keys(resultUpdateObj).length !== 0) {
      functions.logger.info(`Updating following sort fields for product: [${Object.keys(resultUpdateObj)}]`);

      await admin.firestore().collection(productsCollection).doc(snap.after.id).update(resultUpdateObj);
    }
  }
};
