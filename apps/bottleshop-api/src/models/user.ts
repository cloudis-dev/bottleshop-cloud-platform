import { Language } from '../constants/other';
import { userFields } from '../constants/model-constants';

export interface User {
  [userFields.email]: string | undefined;
  [userFields.name]: string;
  [userFields.uid]: string;
  [userFields.billingAddress]: Address;
  [userFields.shippingAddress]: Address;
  [userFields.stripeCustomerId]: string;
  [userFields.phoneNumber]: string;
  [userFields.prefferedLanguage]: Language | undefined;
}

export interface Address {
  streetName: string;
  streetNumber: string;
  city: string;
  zipCode: string;
}
