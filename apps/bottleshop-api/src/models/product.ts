import { productFields } from '../constants/model-constants';

export interface Product {
  [productFields.nameField]: string;
  [productFields.editionField]?: string;
  [productFields.ageField]?: number;
  [productFields.yearField]?: number;
  [productFields.cmatField]: string;
  [productFields.eanField]: string;
  [productFields.priceNoVatField]: number;
  /**
   * This is the quantity in stock.
   */
  [productFields.countField]: number;
  [productFields.unitValueField]: number;
  [productFields.unitRefField]: FirebaseFirestore.DocumentReference;
  [productFields.alcoholField]: number;
  [productFields.categoryRefsField]: [FirebaseFirestore.DocumentReference];
  [productFields.countryRefField]: FirebaseFirestore.DocumentReference;
  [productFields.descriptionSkField]?: string;
  [productFields.descriptionEnField]?: string;
  [productFields.discountField]?: number;
  [productFields.isRecommendedField]?: boolean;
  [productFields.isNewEntryField]?: boolean;
  [productFields.flashSaleModelField]?: object;
  [productFields.thumbnailField]?: string;
  [productFields.imagePathField]?: string;
  [productFields.activePromoCodesCountField]?: number;
}
