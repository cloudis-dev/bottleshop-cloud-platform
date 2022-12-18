import Stripe from 'stripe';

import { DeliveryType } from './order-type';

export type PlatformType = 'web' | 'mobile';

export interface PaymentData {
  orderNote: string;
  deliveryType: DeliveryType;
  platform: PlatformType;
  promoCode: string | undefined;
  cancelUrl: string;
  successUrl: string;
}

export interface StripePaymentMetadata {
  userId: string;
  orderId: string;
  orderNote: string | undefined;
  deliveryType: DeliveryType;
  /**
   * Represents the platform the transaction was created at.
   */
  platform: PlatformType;
  promoCode: string | undefined;
  promoDiscountValue: number | undefined;
}

export interface WebPaymentData extends PaymentData {
  locale: Stripe.Checkout.SessionCreateParams.Locale;
  domain: string;
}
