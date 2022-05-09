export type DeliveryType =
  | 'home-delivery'
  | 'pick-up'
  | 'quick-delivery-BA'
  | 'close-areas-delivery-ba'
  | 'cash-on-delivery';

export interface OrderType {
  code: DeliveryType;
  shipping_fee_eur_no_vat: number;
  name: string;
  localized_name: { sk: string };
}
