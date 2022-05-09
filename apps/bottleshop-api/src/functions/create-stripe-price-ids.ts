import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import Stripe from 'stripe';
import { cartCollection, usersCollection } from '../constants/collections';
import { cartFields } from '../constants/model-constants';
import { tempCartId, tier1Region } from '../constants/other';
import { WebPaymentData } from '../models/payment-data';
import { StripeLineItem } from '../models/stripe-line-item';
import { getCartItemFinalPrice } from '../utils/cart-utils';
import { getCartItems } from './cart/nested-functions/on-cart-updated';
import { generateNewOrderId } from './create-payment-intent';

const stripe = new Stripe(functions.config().stripe.api_key, {
  typescript: true,
  apiVersion: '2020-08-27',
});

export const createStripePriceIds = functions
  .region(tier1Region)
  .https.onCall(async (data: WebPaymentData, context) => {
    try {
      if (context.auth && context.auth.uid) {
        const cartRef = admin
          .firestore()
          .collection(usersCollection)
          .doc(data.userId)
          .collection(cartCollection)
          .doc(tempCartId);
        const cartItems = await getCartItems(cartRef);
        if (cartItems != null && cartItems.length > 0) {
          const lineItems: StripeLineItem[] = [];
          for (const cartItem of cartItems) {
            const product = await stripe.products.create({
              name: cartItem.product.name,
            });
            const price = await stripe.prices.create({
              product: product.id,
              unit_amount: +Math.floor(getCartItemFinalPrice(cartItem) * 100),
              currency: 'eur',
            });
            const item: StripeLineItem = {
              price: price.id,
              quantity: cartItem.quantity,
            };
            lineItems.push(item);
          }
          const cartData = await cartRef.get();
          const shippingFee = cartData.get(
            cartFields.shippingFeeTotal
          ) as string;
          if (shippingFee && shippingFee !== '0') {
            const shippingProduct = await stripe.products.create({
              name:
                data.locale === 'sk' ? 'Poplatok za doručenie' : 'Shipping fee',
            });
            const shippingPrice = await stripe.prices.create({
              product: shippingProduct.id,
              unit_amount: +Math.floor(parseInt(shippingFee, 10) * 100),
              currency: 'eur',
            });
            const shippingLineItem: StripeLineItem = {
              price: shippingPrice.id,
              quantity: 1,
            };
            lineItems.push(shippingLineItem);
          }
          const orderId = await generateNewOrderId();
          const session = await stripe.checkout.sessions.create({
            payment_method_types: ['card'],
            mode: 'payment',
            success_url: `${data.domain}/home/success`,
            cancel_url: `${data.domain}/home/failure`,
            line_items: lineItems,
            locale: data.locale || 'auto',
            metadata: {
              platform: 'web',
              userId: data.userId || 'N/A',
              deliveryType: data.deliveryType || 'N/A',
              orderNote: data.orderNote || '',
              orderId,
            },
          });
          return {
            id: session.id,
          };
        }
      } else {
        return { access: 'denied' };
      }
    } catch (e) {
      functions.logger.error(`failed creating stripe price ids: ${e}`);
      return e;
    }
  });
