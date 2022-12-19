import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import Stripe from 'stripe';

admin.initializeApp(functions.config().firebase);
admin.firestore().settings({
  timestampInSnapshots: true,
  ignoreUndefinedProperties: true,
});

export function createStripeClient(): Stripe {
  return new Stripe(functions.config().stripe.secret_key, {
    typescript: true,
    apiVersion: '2022-11-15',
  });
}

export { createPaymentIntent } from './functions/create-payment-intent';
export { onPaymentStatusUpdate } from './functions/on-payment-status-update';
export { createCheckoutSession } from './functions/create-checkout-session';
export { getCurrentTimestamp } from './functions/timestamp';
export { onOrderWrite } from './functions/on-order-write/on-order-write';
export { onProductWrite } from './functions/on-product-write/on-product-write';
export { createStripeCustomer, onUserWrite } from './functions/on-user-write';
export {
  applyPromoCode,
  onCartUpdated,
  removePromoCode,
  removeShippingFee,
  setShippingFee,
  validateCart,
} from './functions/cart';
export { onCategoryWriteAlgoliaUpdate as onCategoryWrite } from './functions/on-category-write-algolia-update';
export { onAdminUserCreate, onAdminUserDelete } from './functions/on-admin-user-create-delete';
export { createCashOnDeliveryOrder } from './functions/create-cash-on-delivery-order';
export { deleteAccount } from './functions/delete-account';
