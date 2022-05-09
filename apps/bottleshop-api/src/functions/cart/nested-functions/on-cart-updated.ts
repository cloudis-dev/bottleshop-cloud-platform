import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

import {
  Cart,
  CartRecord,
} from '../../../models/cart';
import {
  cartCollection,
  cartItemsSubCollection,
  productsCollection,
  usersCollection,
} from '../../../constants/collections';
import { cartFields } from '../../../constants/model-constants';
import { getCartItemFinalPrice } from '../../../utils/cart-utils';
import { getEntityByRef } from '../../../utils/document-reference-utils';
import { Product } from '../../../models/product';
import {
  tempCartId,
  tier1Region,
  VAT,
} from '../../../constants/other';

export interface CartItem {
  id?: string;
  quantity: number;
  product: Product;
}

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
    const totalPrice = item.quantity * getCartItemFinalPrice(item);

    return {
      total_items: acc.total_items + 1,
      products_total_price: acc.products_total_price + totalPrice,
      products_vat: acc.products_vat + +(totalPrice - totalPrice / (1 + VAT)).toFixed(2),
    };
  }, res);
}

export async function getCartItems(cartRef: FirebaseFirestore.DocumentReference): Promise<CartItem[]> {
  return cartRef
    .collection(cartItemsSubCollection)
    .get()
    .then((val) =>
      Promise.all(
        val.docs.map<Promise<CartItem | undefined>>(async (e) => {
          const data = e.data() as CartRecord;
          const product = await getEntityByRef<Product>(data.product_ref);
          if (product == null) {
            return undefined;
          } else {
            return {
              id: data.product_ref.id,
              quantity: data.quantity,
              product,
            };
          }
        }),
      ).then((e) => e.filter((item): item is CartItem => item != null)),
    );
}

export const areProductsInCartAvailable = async (cartRef: FirebaseFirestore.DocumentReference): Promise<boolean> => {
  const cartItems = await getCartItems(cartRef);

  return Promise.all(
    cartItems.map(async (e) => {
      const currentProd = await getEntityByRef<Product>(
        admin.firestore().collection(productsCollection).doc(e.product.cmat),
      );
      if (currentProd == null) {
        return false;
      }
      return currentProd.amount >= e.quantity;
    }),
  ).then((e) => e.every((isAvailable) => isAvailable));
};

export const onCartUpdated = functions
  .region(tier1Region)
  .firestore.document(`${usersCollection}/{userId}/${cartCollection}/${tempCartId}/${cartItemsSubCollection}/{itemId}`)
  .onWrite(async (_, context) => {
    try {
      return admin.firestore().runTransaction<unknown>(async () => {
        const cartRef: FirebaseFirestore.DocumentReference = admin
          .firestore()
          .collection(`${usersCollection}/${context.params.userId}/${cartCollection}`)
          .doc(tempCartId);
        const [cart, cartItems] = await Promise.all([getEntityByRef<Cart>(cartRef), getCartItems(cartRef)]);

        const summarization = summarizeProductsInCart(cartItems);

        const newCart: Cart = (cartItems.length === 0 ? null : cart) ?? {
          total_items: 0,
          products_total_price: 0,
          products_vat: 0,
        };

        newCart[cartFields.totalItems] = summarization.total_items;
        newCart[cartFields.productsTotalPrice] = +summarization.products_total_price.toFixed(2);
        newCart[cartFields.productsVat] = +summarization.products_vat.toFixed(2);

        return cartRef.set(newCart).then(() =>
          functions.logger.info(`
          Cart updated to following object: ${JSON.stringify(newCart)}
          Products CMATs in cart are: ${cartItems.map((e) => `${e.product.cmat} of count ${e.quantity}`).join(', ')}
          `),
        );
      });
    } catch (err) {
      functions.logger.error(`cart update failed ${err}`);
    }
  });
