import { orderFields } from '../constants/model-constants';
import { Product } from './product';
import { User } from './user';

export interface Order {
  [orderFields.cart]: OrderItem[];
  [orderFields.createdAt]: FirebaseFirestore.Timestamp;
  [orderFields.customer]: User;
  [orderFields.orderId]: number;
  [orderFields.note]: string;
  [orderFields.orderTypeRef]: FirebaseFirestore.DocumentReference;
  [orderFields.preparingAdminRef]?: FirebaseFirestore.DocumentReference;
  [orderFields.statusStepId]: number;
  [orderFields.statusTimestamps]: FirebaseFirestore.Timestamp[];
  [orderFields.totalPaid]: number;
  [orderFields.promoCode]?: string;
  [orderFields.promoCodeValue]?: number;
  [orderFields.oasisSynced]?: boolean;
}

export interface OrderItem {
  count: number;
  paid_price: number;
  product: Product;
}
