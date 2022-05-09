import * as functions from 'firebase-functions';

import { DocumentChange } from '../../models/document-change';
import {
  getDocumentChange,
  hasFieldChanged,
} from '../../utils/document-snapshot-utils';
import { onProductDeleted } from './nested-functions/on-product-deleted';
import { onQuantityUpdated } from './nested-functions/on-quantity-updated';
import { onUpdateAlgolia } from './nested-functions/on-update-algolia';
import { onUpdateCategoryAggregations } from './nested-functions/on-update-category-aggs';
import { onUpdateFilterAggregations } from './nested-functions/on-update-filter-aggs';
import { onUpdateSortFields } from './nested-functions/on-update-sort-fields';
import { productFields } from '../../constants/model-constants';
import { productsCollection } from '../../constants/collections';
import { tier1Region } from '../../constants/other';

export const onProductWrite = functions
  .region(tier1Region)
  .runWith({ memory: '1GB' })
  .firestore.document(`${productsCollection}/{product}`)
  .onWrite(async (snap) => {
    // Update algolia only when it contains all the sort fields or when deleting document
    const containsAllSortFields =
      !snap.after.exists ||
      (snap.after.exists &&
        snap.after.get(productFields.finalPriceField) != null &&
        snap.after.get(productFields.nameSortField) != null);

    // DO NOT update algolia when any of the fields that should be postprocessed (sort fields) was updated.
    // Update algolia after the fields are postgrocessed.
    const fieldsToBePostprocessedUpdated =
      snap.after.exists &&
      (hasFieldChanged(productFields.discountField, snap) ||
        hasFieldChanged(productFields.nameField, snap) ||
        hasFieldChanged(productFields.priceNoVatField, snap));

    await Promise.all([
      onUpdateSortFields(snap),
      onUpdateFilterAggregations(snap),
      containsAllSortFields && !fieldsToBePostprocessedUpdated ? onUpdateAlgolia(snap) : undefined,
      getDocumentChange(snap) === DocumentChange.updated && hasFieldChanged(productFields.countField, snap)
        ? onQuantityUpdated(snap.after)
        : undefined,
      getDocumentChange(snap) === DocumentChange.deleted ? onProductDeleted(snap.before) : undefined,
      onUpdateCategoryAggregations(snap),
    ]);
  });
