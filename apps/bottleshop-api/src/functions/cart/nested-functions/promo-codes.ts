import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import { logger } from 'firebase-functions';

import { Cart } from '../../../models/cart';
import {
  cartCollection,
  promoCodesCollection,
  usersCollection,
} from '../../../constants/collections';
import { cartFields } from '../../../constants/model-constants';
import { getEntityByRef } from '../../../utils/document-reference-utils';
import { PromoCode } from '../../../models/promo-code';
import {
  tempCartId,
  tier1Region,
} from '../../../constants/other';

interface PromoUpdateResult {
  applied: boolean;
}

async function getPromoByCode(code: string): Promise<PromoCode | undefined> {
  const promoRef = admin.firestore().collection(promoCodesCollection).doc(code);
  return getEntityByRef<PromoCode>(promoRef);
}

function isPromoValid(promo: PromoCode, cart: Cart): boolean {
  return promo.remaining_uses_count > 0 && promo.min_cart_value <= cart.products_total_price;
}

function addPromoToCart(promo: PromoCode, cart: Cart): Cart {
  if (cart.promo_code && cart.promo_code_value) {
    logger.warn('PromoCode could not be added as it existed already');
    return cart;
  }

  cart[cartFields.promoCode] = promo.code;
  cart[cartFields.promoCodeValue] = promo.discount_value;

  return cart;
}

function removePromoFromCart(cart: Cart): Cart {
  if (!cart.promo_code && !cart.promo_code_value) {
    logger.warn('PromoCode could not be removed as it was never there');
    return cart;
  }

  delete cart[cartFields.promoCode];
  delete cart[cartFields.promoCodeValue];

  return cart;
}

export const isPromoCodeValid = async (cart: Cart): Promise<boolean> => {
  if (!cart.promo_code) {
    return true;
  }
  const promo = await getPromoByCode(cart.promo_code);
  if (!promo) {
    return false;
  }
  return isPromoValid(promo, cart);
};

export const removePromoCode = functions
  .region(tier1Region)
  .https.onCall(async (_, context: functions.https.CallableContext): Promise<PromoUpdateResult> => {
    if (context.auth && context.auth.uid) {
      const cartRef = admin
        .firestore()
        .collection(usersCollection)
        .doc(context.auth.uid)
        .collection(cartCollection)
        .doc(tempCartId);
      const cart = await getEntityByRef<Cart>(cartRef);
      if (cart) {
        const newCart = removePromoFromCart(cart);
        await cartRef.set(newCart);
        return { applied: true };
      }
    }
    return { applied: false };
  });

export const applyPromoCode = functions
  .region(tier1Region)
  .https.onCall(
    async (data: { promo: string }, context: functions.https.CallableContext): Promise<PromoUpdateResult> => {
      if (context.auth && context.auth.uid) {
        const uid = context.auth.uid;
        return admin.firestore().runTransaction<PromoUpdateResult>(async () => {
          const promo = await getPromoByCode(data.promo);
          if (promo) {
            const cartRef = admin
              .firestore()
              .collection(usersCollection)
              .doc(uid)
              .collection(cartCollection)
              .doc(tempCartId);
            const cart = await getEntityByRef<Cart>(cartRef);
            if (cart) {
              if (isPromoValid(promo, cart)) {
                const newCart = addPromoToCart(promo, cart);
                await cartRef.set(newCart);
                return { applied: true };
              }
            }
            return { applied: false };
          }
          return { applied: false };
        });
      }
      return { applied: false };
    },
  );
