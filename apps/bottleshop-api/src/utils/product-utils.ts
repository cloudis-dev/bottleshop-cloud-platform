import { VAT } from '../constants/other';
import { Product } from '../models/product';
import * as admin from 'firebase-admin';
import { productsCollection } from '../constants/collections';
import { getEntityByRef } from './document-reference-utils';
/**
 * Calculates price of the product with VAT and discount applied if any.
 * The price is returned with 2 decimal places.
 */
export function calculateProductFinalPrice(product: Product): number {
  return +(product.price_no_vat * (1 - (product.discount ?? 0)) * (1 + VAT)).toFixed(2);
}

/**
 * Product price with discount applied without rounding.
 */
export function finalProductPriceNoVatNoRounding(product: Product): number {
  return product.price_no_vat * (1 - (product.discount ?? 0));
}

/**
 * Get the product's image url.
 * When product has no image, return just the placeholder image.
 */
export async function getProductImageUrl(product: Product): Promise<string | undefined> {
  if (product.image_path === undefined) {
    return undefined;
  } else {
    const file = admin.storage().bucket().file(product.image_path);
    await file.makePublic();
    return file.publicUrl();
  }
}

export function getProductRef(productUid: string): FirebaseFirestore.DocumentReference {
  return admin.firestore().collection(productsCollection).doc(productUid);
}
/**
 * Get the product from firestore.
 * @param productUid Our product UID is the product's cmat
 */
export function getProduct(productUid: string): Promise<Product | undefined> {
  const prodRef = admin.firestore().collection(productsCollection).doc(productUid);
  return getEntityByRef<Product>(prodRef);
}
