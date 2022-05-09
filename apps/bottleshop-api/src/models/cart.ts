import { cartFields } from '../constants/model-constants';
import { DeliveryType } from './order-type';

export interface Cart {
  [cartFields.totalItems]: number;
  [cartFields.productsTotalPrice]: number;
  [cartFields.productsVat]: number;
  [cartFields.shipping]?: DeliveryType;
  [cartFields.shippingFeeTotal]?: number;
  [cartFields.shippingVat]?: number;
  [cartFields.promoCode]?: string;
  [cartFields.promoCodeValue]?: number;
}

export interface CartRecord {
  product_ref: FirebaseFirestore.DocumentReference;
  quantity: number;
}
