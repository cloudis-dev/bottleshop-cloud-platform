import deepEqual from 'deep-equal';
import * as functions from 'firebase-functions';

import { approximately } from './math-utils';
import { DocumentChange } from '../models/document-change';

/**
 * Get document change - created, updated, deleted.
 * @param snap
 * @returns
 */
export function getDocumentChange(snap: functions.Change<functions.firestore.DocumentSnapshot>): DocumentChange {
  if (!snap.before.exists && snap.after.exists) {
    return DocumentChange.created;
  } else if (snap.before.exists && !snap.after.exists) {
    return DocumentChange.deleted;
  } else {
    return DocumentChange.updated;
  }
}

/**
 * Check if previous value and the new value of the specified field has changed.
 * It returns true when document is created and deleted, too (the value of field is changed).
 *
 *
 * In case the value is a number the `approximately(a, b)` comparison of the values is used.
 *
 * @param field
 * @param snap
 * @returns
 */
export function hasFieldChanged(field: string, snap: functions.Change<functions.firestore.DocumentSnapshot>): boolean {
  const before = snap.before.get(field);
  const after = snap.after.get(field);

  if (!isNaN(before) || !isNaN(after)) {
    return !approximately(before, after);
  }
  return !deepEqual(before, after, { strict: true });
}
