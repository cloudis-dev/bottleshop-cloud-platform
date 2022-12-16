export const productFields = {
  finalPriceField: '_final_price',
  nameSortField: '_name_sort',
  nameField: 'name',
  editionField: 'edition',
  ageField: 'age',
  yearField: 'year',
  cmatField: 'cmat',
  eanField: 'ean',
  priceNoVatField: 'price_no_vat',
  /**
   * This is the quantity in stock.
   */
  countField: 'amount',
  unitValueField: 'unit_value',
  unitRefField: 'unit_ref',
  alcoholField: 'alcohol',
  categoryRefsField: 'category_refs',
  countryRefField: 'country_ref',
  descriptionSkField: 'description_sk',
  descriptionEnField: 'description_en',
  discountField: 'discount',
  isRecommendedField: 'is_recommended',
  isNewEntryField: 'is_new_entry',
  flashSaleModelField: 'flash_sale',
  thumbnailField: 'thumbnail_path',
  imagePathField: 'image_path',
  activePromoCodesCountField: 'active_promo_codes_count',
} as const;

export const orderFields = {
  cart: 'cart',
  createdAt: 'created_at',
  customer: 'customer',
  orderId: 'id',
  note: 'note',
  orderTypeRef: 'order_type_ref',
  preparingAdminRef: 'preparing_admin_ref',
  statusStepId: 'status_step_id',
  statusTimestamps: 'status_timestamps',
  totalPaid: 'total_paid',
  shippingFeeNoVat: 'shipping_fee_no_vat',
  promoCode: 'promo_code',
  promoCodeValue: 'promo_code_value',
  oasisSynced: 'oasis_synced',
} as const;

export const userFields = {
  email: 'email',
  name: 'name',
  uid: 'uid',
  billingAddress: 'billing_address',
  shippingAddress: 'shipping_address',
  phoneNumber: 'phone_number',
  stripeCustomerId: 'stripe_customer_id',
  prefferedLanguage: 'preferred_language',
} as const;

export const cartItemFields = {
  productRef: 'product_ref',
  quantity: 'quantity',
} as const;

export const cartFields = {
  totalItems: 'total_items',
  productsTotalPrice: 'products_total_price',
  productsVat: 'products_vat',
  shipping: 'shipping',
  shippingFeeTotal: 'shipping_fee_total',
  shippingVat: 'shipping_vat',
  promoCode: 'promo_code',
  promoCodeValue: 'promo_code_value',
} as const;

export const wishlistItemFields = {
  productRef: 'product',
  addedAt: 'added_at',
} as const;

export const categoryFields = {
  uid: 'uid',
  subcategoriesRefs: 'subcategories_refs',
} as const;

export const promoCodeFields = {
  stripeCouponId: 'stripe_coupon_id',
  discountValue: 'discount_value',
} as const;
