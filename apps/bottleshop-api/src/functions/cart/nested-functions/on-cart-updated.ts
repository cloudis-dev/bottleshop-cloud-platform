import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import { calculateProductFinalPrice } from '../../../utils/product-utils';
import { Cart } from '../../../models/cart';
import { cartFields } from '../../../constants/model-constants';

import { cartCollection, cartItemsSubCollection, usersCollection } from '../../../constants/collections';
import { tempCartId, tier1Region, VAT } from '../../../constants/other';
import { CartItem, getCart, getCartItems, getCartRef } from '../../../utils/cart-utils';

interface Summarization {
  total_items: number;
  products_total_price: number;
  products_vat: number;
}

function summarizeProductsInCart(cartItems: CartItem[]): Summarization {
  const res: Summarization = { total_items: 0, products_total_price: 0, products_vat: 0 };
  if (cartItems.length === 0) {
    return res;
  }

  return cartItems.reduce<Summarization>((acc, item): Summarization => {
    const totalPrice = item.quantity * calculateProductFinalPrice(item.product);

    return {
      total_items: acc.total_items + 1,
      products_total_price: acc.products_total_price + totalPrice,
      products_vat: acc.products_vat + +(totalPrice - totalPrice / (1 + VAT)).toFixed(2),
    };
  }, res);
}

export const onCartUpdated = functions
  .region(tier1Region)
  .firestore.document(`${usersCollection}/{userId}/${cartCollection}/${tempCartId}/${cartItemsSubCollection}/{itemId}`)
  .onWrite(async (_, context) => {
    try {
      return admin.firestore().runTransaction<unknown>(async () => {
        const [cart, cartItems] = await Promise.all([
          getCart(context.params.userId),
          getCartItems(context.params.userId),
        ]);

        const summarization = summarizeProductsInCart(cartItems);

        const newCart: Cart = (cartItems.length === 0 ? null : cart) ?? {
          total_items: 0,
          products_total_price: 0,
          products_vat: 0,
        };

        newCart[cartFields.totalItems] = summarization.total_items;
        newCart[cartFields.productsTotalPrice] = +summarization.products_total_price.toFixed(2);
        newCart[cartFields.productsVat] = +summarization.products_vat.toFixed(2);

        return getCartRef(context.params.userId)
          .set(newCart)
          .then(() =>
            functions.logger.info(`
          Cart updated to following object: ${JSON.stringify(newCart)}
          Products CMATs in cart are: ${cartItems.map((e) => `${e.product.cmat} of count ${e.quantity}`).join(', ')}
          `),
          );
      });
    } catch (err) {
      functions.logger.error(`cart update failed ${err}`);
      return null;
    }
  });
