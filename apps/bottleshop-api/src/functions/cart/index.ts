import * as admin from 'firebase-admin';
import { CallableContext } from 'firebase-functions/lib/providers/https';
import * as functions from 'firebase-functions';

import { areProductsInCartAvailable } from './nested-functions/on-cart-updated';
import { Cart } from '../../models/cart';
import {
  cartCollection,
  usersCollection,
} from '../../constants/collections';
import { getEntityByRef } from '../../utils/document-reference-utils';
import { isPromoCodeValid } from './nested-functions/promo-codes';
import {
  tempCartId,
  tier1Region,
} from '../../constants/other';

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
      const cartRef = admin
        .firestore()
        .collection(usersCollection)
        .doc(context.auth.uid)
        .collection(cartCollection)
        .doc(tempCartId);
      const cart = await getEntityByRef<Cart>(cartRef);

      if (!cart) {
        return { status: 'no-cart' };
      }

      if (!(await isPromoCodeValid(cart))) {
        return { status: 'invalid-promo' };
      }

      if (!(await areProductsInCartAvailable(cartRef))) {
        return { status: 'unavailable-products' };
      }

      return { status: 'ok' };
    } else {
      return { status: 'unauthenticated' };
    }
  });
