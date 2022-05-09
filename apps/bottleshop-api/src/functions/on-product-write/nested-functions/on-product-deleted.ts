import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

import {
  cartCollection,
  cartItemsSubCollection,
  productsCollection,
  wishlistSubCollection,
} from '../../../constants/collections';
import {
  cartItemFields,
  wishlistItemFields,
} from '../../../constants/model-constants';
import { Product } from '../../../models/product';

export const onProductDeleted = async (productSnapshot: functions.firestore.DocumentSnapshot) => {
  const product = productSnapshot.data() as Product;

  await Promise.all([deleteAllCartRefs(product.cmat), deleteAllFavoriteRefs(product.cmat)]);
};

async function deleteAllFavoriteRefs(productCmat: string): Promise<void> {
  const refs = await admin
    .firestore()
    .collectionGroup(wishlistSubCollection)
    .where(wishlistItemFields.productRef, '==', admin.firestore().collection(productsCollection).doc(productCmat))
    .get()
    .then((snap) => snap.docs.map((e) => e.ref));

  await Promise.all(refs.map((e) => e.delete()));
  functions.logger.log(
    `Removed all the references of product CMAT=${productCmat} from wishlists. Total of ${refs.length} references.`,
  );
}

async function deleteAllCartRefs(productCmat: string): Promise<void> {
  const cartItemRefs = await admin
    .firestore()
    .collectionGroup(cartItemsSubCollection)
    .where(cartItemFields.productRef, '==', admin.firestore().collection(productsCollection).doc(productCmat))
    .get()
    .then((snap) => snap.docs.filter((doc) => doc.ref.parent?.parent?.parent.id === cartCollection).map((e) => e.ref));

  await Promise.all(cartItemRefs.map((e) => e.delete()));

  functions.logger.log(
    `Removed all the references of product CMAT=${productCmat} from carts. Total of ${cartItemRefs.length} references.`,
  );
}
