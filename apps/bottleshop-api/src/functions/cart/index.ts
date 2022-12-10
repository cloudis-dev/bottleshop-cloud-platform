import { CallableContext } from 'firebase-functions/lib/providers/https';
import * as functions from 'firebase-functions';

import { isPromoCodeValid } from './nested-functions/promo-codes';
import { tier1Region } from '../../constants/other';
import { areProductsAvailableForPurchase, getCart, getCartItems } from '../../utils/cart-utils';

export type CartUpdateResult = { updated: string } | { error: string };

export { removeShippingFee, setShippingFee } from './nested-functions/shipping-fees';
export { applyPromoCode, removePromoCode } from './nested-functions/promo-codes';
export { onCartUpdated } from './nested-functions/on-cart-updated';

interface ValidationResult {
  status: string;
}

export const validateCart = functions
  .region(tier1Region)
  .https.onCall(async (_, context: CallableContext): Promise<ValidationResult> => {
    if (context.auth && context.auth.uid) {
      const cart = await getCart(context.auth.uid);

      if (cart === undefined) {
        return { status: 'no-cart' };
      }

      if (!(await isPromoCodeValid(cart))) {
        return { status: 'invalid-promo' };
      }

      const cartItems = await getCartItems(context.auth.uid);
      if (!(await areProductsAvailableForPurchase(cartItems))) {
        return { status: 'unavailable-products' };
      }

      return { status: 'ok' };
    } else {
      return { status: 'unauthenticated' };
    }
  });
