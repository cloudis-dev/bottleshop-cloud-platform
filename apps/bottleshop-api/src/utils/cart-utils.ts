import { Cart, CartRecord } from '../models/cart';
import { tempCartId } from '../constants/other';
import * as admin from 'firebase-admin';
import { usersCollection, cartCollection, cartItemsSubCollection } from '../constants/collections';
import { Product } from '../models/product';
import { getEntityByRef } from './document-reference-utils';

export interface CartItem {
  id: string;
  quantity: number;
  product: Product;
}

export function getCartTotalPrice(cart: Cart): number {
  return +(cart.products_total_price + (cart.shipping_fee_total ?? 0) - (cart.promo_code_value ?? 0)).toFixed(2);
}

export function getCartRef(userId: string): FirebaseFirestore.DocumentReference {
  return admin.firestore().collection(`${usersCollection}/${userId}/${cartCollection}`).doc(tempCartId);
}

export function getCart(userId: string): Promise<Cart | undefined> {
  const cartRef = getCartRef(userId);
  return getEntityByRef<Cart>(cartRef);
}

export async function getCartItems(userId: string): Promise<CartItem[]> {
  const itemsSnap = await getCartRef(userId).collection(cartItemsSubCollection).get();

  return Promise.all<CartItem | undefined>(
    itemsSnap.docs.map(async (item) => {
      const cartRecord: CartRecord = item.data() as CartRecord;
      const product = await getEntityByRef<Product>(cartRecord.product_ref);
      if (product === undefined) {
        return undefined;
      } else {
        return {
          id: cartRecord.product_ref.id,
          quantity: cartRecord.quantity,
          product,
        };
      }
    }),
  ).then((res) => res.filter((item): item is CartItem => item !== undefined));
}
