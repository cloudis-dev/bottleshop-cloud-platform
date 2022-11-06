import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import { logger } from 'firebase-functions';

import { Cart } from '../../../models/cart';
import { cartCollection, orderTypesCollection, usersCollection } from '../../../constants/collections';
import { cartFields } from '../../../constants/model-constants';
import { CartUpdateResult } from '..';
import { DeliveryType, OrderType } from '../../../models/order-type';
import { getEntityByRef } from '../../../utils/document-reference-utils';
import { tempCartId, tier1Region, VAT } from '../../../constants/other';

async function getOrderTypeByCode(shippingCode: string): Promise<OrderType | undefined> {
  const docs = await admin.firestore().collection(orderTypesCollection).where('code', '==', shippingCode).get();
  if (docs.empty) {
    return undefined;
  }
  return docs.docs[0].data() as OrderType;
}

async function addShippingToCart(orderType: OrderType, cart: Cart): Promise<Cart> {
  cart = await removeShippingFromCart(cart);

  const shippingFee = +(orderType.shipping_fee_eur_no_vat * (1 + VAT)).toFixed(2);
  const shippingVat = +(shippingFee - orderType.shipping_fee_eur_no_vat).toFixed(2);

  cart[cartFields.shipping] = orderType.code;
  cart[cartFields.shippingFeeTotal] = shippingFee;
  cart[cartFields.shippingVat] = shippingVat;

  return cart;
}

async function removeShippingFromCart(cart: Cart): Promise<Cart> {
  if (cart.shipping === undefined) {
    return cart;
  }

  const currentOrderType = await getOrderTypeByCode(cart.shipping);
  if (currentOrderType === undefined) {
    return Promise.reject(`No such order type exists with code: ${cart.shipping}`);
  }

  delete cart[cartFields.shipping];
  delete cart[cartFields.shippingFeeTotal];
  delete cart[cartFields.shippingVat];

  return cart;
}

export const setShippingFee = functions
  .region(tier1Region)
  .https.onCall(
    async (data: { shipping: DeliveryType }, context: functions.https.CallableContext): Promise<CartUpdateResult> => {
      const userUid = context.auth?.uid;
      if (userUid !== undefined) {
        return admin.firestore().runTransaction<CartUpdateResult>(async () => {
          const cartRef = admin
            .firestore()
            .collection(usersCollection)
            .doc(userUid)
            .collection(cartCollection)
            .doc(tempCartId);
          const [cart, newOrderType] = await Promise.all([
            getEntityByRef<Cart>(cartRef),
            getOrderTypeByCode(data.shipping),
          ]);

          if (newOrderType === undefined) {
            const err = 'No such order type exists';
            logger.error(err);
            return { error: err };
          }

          if (cart !== undefined) {
            return addShippingToCart(newOrderType, cart)
              .then(async (newCart) => {
                await cartRef.set(newCart);
                return { updated: 'success' };
              })
              .catch((err) => {
                return { error: err };
              });
          }
          return { error: 'Cart does not exist!' };
        });
      } else {
        return { error: 'denied' };
      }
    },
  );

export const removeShippingFee = functions
  .region(tier1Region)
  .https.onCall(async (_, context: functions.https.CallableContext): Promise<CartUpdateResult> => {
    const userUid = context.auth?.uid;
    if (userUid !== undefined) {
      return admin.firestore().runTransaction<CartUpdateResult>(async () => {
        const cartRef = admin
          .firestore()
          .collection(usersCollection)
          .doc(userUid)
          .collection(cartCollection)
          .doc(tempCartId);
        const cart = await getEntityByRef<Cart>(cartRef);

        if (cart !== undefined) {
          return removeShippingFromCart(cart)
            .then(async (newCart) => {
              await cartRef.set(newCart);
              return { updated: 'success' };
            })
            .catch((err) => {
              return { error: err };
            });
        }
        return { error: 'Cart does not exist!' };
      });
    } else {
      return { error: 'denied' };
    }
  });
