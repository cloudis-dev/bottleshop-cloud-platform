import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

admin.initializeApp(functions.config().firebase);
const settings = { timestampInSnapshots: true };
admin.firestore().settings(settings);

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
export { postFeedback } from './functions/post-feedback';
