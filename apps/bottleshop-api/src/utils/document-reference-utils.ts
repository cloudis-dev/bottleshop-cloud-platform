/**
 * Get entity by a document reference.
 * @param userDocRef
 * @returns
 */
export const getEntityByRef = async <T>(
  ref: FirebaseFirestore.DocumentReference | undefined,
): Promise<T | undefined> => {
  if (ref === undefined) {
    return undefined;
  }

  const doc = await ref.get();

  if (doc.data() === undefined) {
    return undefined;
  }

  return doc.data() as T;
};
