/**
 * Get entity by a document reference.
 * @param userDocRef
 * @returns
 */
export const getEntityByRef = async <T>(
  userDocRef: FirebaseFirestore.DocumentReference | undefined,
): Promise<T | undefined> => {
  if (userDocRef == null) {
    return undefined;
  }

  const doc = await userDocRef.get();

  if (doc.data() == null) {
    return undefined;
  }

  return doc.data() as T;
};
