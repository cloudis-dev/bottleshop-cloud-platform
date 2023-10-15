import { Cart, CartRecord } from '../models/cart';
import { VAT, tempCartId } from '../constants/other';
import * as admin from 'firebase-admin';
import { usersCollection, cartCollection, cartItemsSubCollection, productsCollection } from '../constants/collections';
import { Product } from '../models/product';
import { getEntityByRef } from './document-reference-utils';
import { PromoCode } from '../models/promo-code';
import { OrderType } from '../models/order-type';
import { calculateProductFinalPrice, finalProductPriceNoVatNoRounding } from './product-utils';

export interface CartItem {
  id: string;
  quantity: number;
  product: Product;
}

export function getCartTotalPrice(cart: Cart): number {
  return +(cart.products_total_price + (cart.shipping_fee_total ?? 0) - (cart.promo_code_value ?? 0)).toFixed(2);
}

export async function getCartTotalPriceV2( 
  userId: string,
  orderType: OrderType,
  promoCode: PromoCode | undefined,
): Promise<number> {
  const cartItems = await getCartItems(userId);
  const totalSum = cartItems.map((item) => item.quantity * calculateProductFinalPrice(item.product)).reduce((acc, a) => a + acc);
  if(promoCode?.promo_code_type == 'percent')
    promoCode.discount_value = promoCode!.discount_value / 100 *  totalSum;
  return +(
    (orderType.shipping_fee_eur_no_vat +
      cartItems
        .map((item) => item.quantity * finalProductPriceNoVatNoRounding(item.product))
        .reduce((sum, current) => sum + current, 0)) *
      (1 + VAT) -
      (promoCode?.promo_code_type == 'percent'
      ? promoCode.discount_value
      : (promoCode?.discount_value ?? 0))
  ).toFixed(2);
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

export async function areProductsAvailableForPurchase(cartItems: CartItem[]): Promise<boolean> {
  return Promise.all(
    cartItems.map(async (e) => {
      const currentProd = await getEntityByRef<Product>(
        admin.firestore().collection(productsCollection).doc(e.product.cmat),
      );
      if (currentProd === undefined) {
        return false;
      }
      return currentProd.amount >= e.quantity;
    }),
  ).then((e) => e.every((isAvailable) => isAvailable));
}

export async function deleteAllCartItems(userId: string) {
  const db = admin.firestore();
  const cartRef = getCartRef(userId).collection(cartItemsSubCollection);
  const batch = db.batch();
  const documents = await cartRef.listDocuments();
  for (const doc of documents) {
    batch.delete(doc);
  }
  await batch.commit();
}
