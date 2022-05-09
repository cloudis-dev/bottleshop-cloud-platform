import { Cart } from '../models/cart';
import { CartItem } from '../functions/cart/nested-functions/on-cart-updated';
import { VAT } from '../constants/other';

export function getCartItemFinalPrice(item: CartItem): number {
  return +(item.product.price_no_vat * (1 - (item.product.discount ?? 0)) * (1 + VAT)).toFixed(2);
}

export function getCartTotalPrice(cart: Cart): number {
  return +(cart.products_total_price + (cart.shipping_fee_total ?? 0) - (cart.promo_code_value ?? 0)).toFixed(2);
}
