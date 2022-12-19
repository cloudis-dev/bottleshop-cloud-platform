import * as admin from 'firebase-admin';
import { getEntityByRef } from './document-reference-utils';
import { PromoCode } from '../models/promo-code';
import { promoCodesCollection } from '../constants/collections';
import { Cart } from '../models/cart';
import { OrderType } from '../models/order-type';
import { CartItem } from './cart-utils';
import { calculateProductFinalPrice } from './product-utils';

export async function getPromoByCode(code: string): Promise<PromoCode | undefined> {
  const promoRef = admin.firestore().collection(promoCodesCollection).doc(code);
  return getEntityByRef<PromoCode>(promoRef);
}

/**
 * V1 is working with automatically updated cart document in firestore.
 */
export function isPromoValidV1(promo: PromoCode, cart: Cart): boolean {
  return promo.remaining_uses_count > 0 && promo.min_cart_value <= cart.products_total_price;
}

/**
 * V2 is not working with the automatically updated values in cart in the firestore,
 * since shipping and promo codes are not part of it anymore.
 * @param promo
 * @param orderType
 * @param cartItems
 * @returns
 */
export function isPromoValidV2(promo: PromoCode, orderType: OrderType, cartItems: CartItem[]): boolean {
  return (
    promo.remaining_uses_count > 0 &&
    promo.min_cart_value <=
      orderType.shipping_fee_eur_no_vat +
        cartItems.map((item) => calculateProductFinalPrice(item.product)).reduce((acc, a) => a + acc)
  );
}
