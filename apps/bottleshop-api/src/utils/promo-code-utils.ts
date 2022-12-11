import * as admin from 'firebase-admin';
import { getEntityByRef } from './document-reference-utils';
import { PromoCode } from '../models/promo-code';
import { promoCodesCollection } from '../constants/collections';
import { Cart } from '../models/cart';

export async function getPromoByCode(code: string): Promise<PromoCode | undefined> {
  const promoRef = admin.firestore().collection(promoCodesCollection).doc(code);
  return getEntityByRef<PromoCode>(promoRef);
}

export function isPromoValid(promo: PromoCode, cart: Cart): boolean {
  return promo.remaining_uses_count > 0 && promo.min_cart_value <= cart.products_total_price;
}
