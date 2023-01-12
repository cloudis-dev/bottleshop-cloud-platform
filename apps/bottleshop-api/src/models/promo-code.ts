import { promoCodeFields } from '../constants/model-constants';

export interface PromoCode {
  code: string;
  [promoCodeFields.discountValue]: number;
  min_cart_value: number;
  remaining_uses_count: number;
  [promoCodeFields.stripeCouponId]: string | undefined;
}
