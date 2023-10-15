import * as admin from 'firebase-admin';
import { getEntityByRef } from './document-reference-utils';
import { PromoCode } from '../models/promo-code';
import { promoCodesCollection } from '../constants/collections';
import { Cart } from '../models/cart';
import { OrderType } from '../models/order-type';
import { CartItem } from './cart-utils';
import { calculateProductFinalPrice } from './product-utils';

export async function getPromoByCode(
  code: string,
): Promise<[PromoCode, FirebaseFirestore.DocumentReference] | undefined> {
  const promoRef = admin.firestore().collection(promoCodesCollection).doc(code);
  const promo = await getEntityByRef<PromoCode>(promoRef);
  return promo === undefined ? undefined : [promo, promoRef];
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
        cartItems.map((item) => item.quantity * calculateProductFinalPrice(item.product)).reduce((acc, a) => a + acc)
  );
}

/**
 * Updates promo code uses (subtract 1 from promo uses count).
 */
export async function usePromoCode(promoId: string | undefined) {
  if (promoId) {
    await admin.firestore().runTransaction(async () => {
      const promoRes = await getPromoByCode(promoId);
      if (promoRes === undefined) {
        return;
      }
      const newRemainingUsesCount = promoRes[0].remaining_uses_count > 0 ? promoRes[0].remaining_uses_count - 1 : 0;
      await promoRes[1].update({ remaining_uses_count: newRemainingUsesCount });
    });
  }
}
