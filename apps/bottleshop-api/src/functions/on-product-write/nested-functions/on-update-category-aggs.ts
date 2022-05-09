import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

import { aggregationsCollection } from '../../../constants/collections';
import { hasFieldChanged } from '../../../utils/document-snapshot-utils';
import { Product } from '../../../models/product';
import { productFields } from '../../../constants/model-constants';

export const onUpdateCategoryAggregations = async (snap: functions.Change<functions.firestore.DocumentSnapshot>) => {
  if (!hasFieldChanged(productFields.categoryRefsField, snap)) {
    return;
  }

  const productAfter: Product | undefined = snap.after.data() as Product;
  const productBefore: Product | undefined = snap.before.data() as Product;

  const categoryIdsBefore = productBefore?.category_refs?.map((e) => e.id) ?? [];
  const categoryIdsAfter = productAfter?.category_refs?.map((e) => e.id) ?? [];

  await Promise.all([
    ...categoryIdsBefore.map((id) =>
      admin
        .firestore()
        .collection(aggregationsCollection)
        .doc('products_count_per_categories')
        .set(
          {
            [id]: admin.firestore.FieldValue.increment(-1),
          },
          { merge: true },
        ),
    ),
    ...categoryIdsAfter.map((id) =>
      admin
        .firestore()
        .collection(aggregationsCollection)
        .doc('products_count_per_categories')
        .set(
          {
            [id]: admin.firestore.FieldValue.increment(1),
          },
          { merge: true },
        ),
    ),
  ]);
};
