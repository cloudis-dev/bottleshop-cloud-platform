import Stripe from 'stripe';

import { DeliveryType } from './order-type';

export type PlatformType = 'web' | 'mobile';

export interface PaymentData {
  orderNote: string;
  deliveryType: DeliveryType;
  platform: PlatformType;
  cancelUrl: string;
  successUrl: string;
}

export interface StripePaymentMetadata {
  orderNote: string | undefined;
  deliveryType: DeliveryType;
  /**
   * Represents the platform the transaction was created at.
   */
  platform: PlatformType;
}

export interface WebPaymentData extends PaymentData {
  locale: Stripe.Checkout.SessionCreateParams.Locale;
  domain: string;
}
