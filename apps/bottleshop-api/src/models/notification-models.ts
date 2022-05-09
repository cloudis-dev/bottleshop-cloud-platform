export interface AdminNewOrderNotification {
  new_order_uid: string;
}

export interface AdminOutOfStockNotification {
  product_uid: string;
}

export interface CustomerOrderNotification {
  order_id: string;
  document_id: string;
}
