import Stripe from 'stripe';

import { DeliveryType } from './order-type';

export interface PaymentData {
  userId: string;
  customerId: string;
  email: string;
  orderNote: string;
  deliveryType: DeliveryType;
}

export interface WebPaymentData extends PaymentData {
  locale: Stripe.Checkout.SessionCreateParams.Locale;
  domain: string;
}
