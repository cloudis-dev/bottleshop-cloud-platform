import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

import {
  aggregationsCollection,
  productsCollection,
} from '../../../constants/collections';
import { hasFieldChanged } from '../../../utils/document-snapshot-utils';
import { productFields } from '../../../constants/model-constants';

const aggregationsFiltersDocument = 'filters';

const aggsUsedCountriesField = 'used_countries';
const maxAgeYearField = 'max_age';
const aggsMinYearField = 'min_year';

/**
 * Update data aggregations about the products in a separate collection.
 *
 * In case of no available aggregation (e.g. no existing product with age field) the aggregation field is deleted.
 */
export const onUpdateFilterAggregations = async (snap: functions.Change<functions.firestore.DocumentSnapshot>) => {
  const updateObjs = await Promise.all([updateMaxAge(snap), updateMinYear(snap), updateUsedCountries(snap)]);

  const resultUpdateObj = Object.assign({}, ...updateObjs);

  if (Object.keys(resultUpdateObj).length === 0) {
    return;
  }

  await admin.firestore().collection(aggregationsCollection).doc(aggregationsFiltersDocument).update(resultUpdateObj);
};

async function updateMaxAge(snap: functions.Change<functions.firestore.DocumentSnapshot>): Promise<object> {
  if (!hasFieldChanged(productFields.ageField, snap)) {
    return {};
  }

  const ages = (
    await admin.firestore().collection(productsCollection).where(productFields.ageField, '>=', 0).get()
  ).docs.map((doc) => doc.get(productFields.ageField));

  if (ages.length === 0) {
    return {
      [maxAgeYearField]: admin.firestore.FieldValue.delete(),
    };
  }
  return {
    [maxAgeYearField]: Math.max(...ages),
  };
}

async function updateMinYear(snap: functions.Change<functions.firestore.DocumentSnapshot>): Promise<object> {
  if (!hasFieldChanged(productFields.yearField, snap)) {
    return {};
  }

  const years = (
    await admin.firestore().collection(productsCollection).where(productFields.yearField, '>=', 0).get()
  ).docs.map((doc) => doc.get(productFields.yearField));

  if (years.length === 0) {
    return {
      [aggsMinYearField]: admin.firestore.FieldValue.delete(),
    };
  }

  return {
    [aggsMinYearField]: Math.min(...years),
  };
}

async function updateUsedCountries(snap: functions.Change<functions.firestore.DocumentSnapshot>): Promise<object> {
  if (!hasFieldChanged(productFields.countryRefField, snap)) {
    return {};
  }

  // deleted
  if (!snap.after.exists) {
    return {
      [aggsUsedCountriesField]: admin.firestore.FieldValue.arrayRemove(snap.before.get(productFields.countryRefField)),
    };
  }

  // created or updated
  return {
    [aggsUsedCountriesField]: admin.firestore.FieldValue.arrayUnion(snap.after.get(productFields.countryRefField)),
  };
}
