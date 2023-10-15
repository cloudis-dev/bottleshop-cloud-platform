import { promoCodeFields } from '../constants/model-constants';

export type PromoType =
  | 'percent'
  | 'value';


export interface PromoCode {
  code: string;
  [promoCodeFields.discountValue]: number;
  min_cart_value: number;
  remaining_uses_count: number;
  [promoCodeFields.stripeCouponId]: string | undefined;
  promo_code_type: PromoType;
}
