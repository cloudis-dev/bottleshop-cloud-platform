import * as admin from 'firebase-admin';

import { getPriceNumberString } from './formatting-utils';
import { Language, VAT } from '../constants/other';
import { Mail } from '../models/mail';
import { managementMailsCollection } from '../constants/collections';
import { Order } from '../models/order';
import { OrderType } from '../models/order-type';

/**
 * Create mail object to be stored in firestore mails collection.
 *
 * @param to
 * @param subject
 * @param text
 * @param html
 * @returns
 */
export function createMail(to: string, subject: string, text = '', html = ''): Mail {
  return {
    to,
    message: {
      subject,
      text,
      html,
    },
  };
}

/**
 * Get all the management mails from the firestore.
 * This goes into the firestore database.
 *
 * @returns
 */
export async function getManagementEmails(): Promise<string[]> {
  return admin
    .firestore()
    .collection(managementMailsCollection)
    .get()
    .then((snap) => snap.docs.map((doc) => doc.id));
}

/**
 * Create order details string describing the order to be used in a mail.
 */
export function getOrderDetailsForMail(order: Order, orderType: OrderType, lang: Language): string {
  let tmp = `${lang === 'sk' ? 'Nová objednávka' : 'New order'}.
    ${lang === 'sk' ? 'Typ objednávky' : 'Order type'}: ${orderType.localized_name.sk}
    ${lang === 'sk' ? 'Zákazník' : 'Customer'}: ${order.customer.name}
    ${lang === 'sk' ? 'Email' : 'Email'}: ${order.customer.email}
    ${lang === 'sk' ? 'Číslo' : 'Number'}: ${order.customer.phone_number}
    ${lang === 'sk' ? 'Poznámka' : 'Note'}: ${order.note}
    `;

  tmp +=
    order.promo_code !== undefined
      ? `${lang === 'sk' ? 'Promo' : 'Promo'}: ${order.promo_code}
    ${lang === 'sk' ? 'Promo zľava' : 'Promo discount'}: -€${getPriceNumberString(order.promo_code_value ?? 0)}
    `
      : '';

  return (
    tmp +
    `
    ${order.cart
      .map(
        (item) => `${lang === 'sk' ? 'Produkt' : 'Product'}: ${item.product.name}
        ${lang === 'sk' ? 'Počet' : 'Count'}: ${item.count}
        ${lang === 'sk' ? 'Cena' : 'Price'}: ${getPriceNumberString(item.paid_price)}
        `,
      )
      .join('\n')}
    ${lang === 'sk' ? 'Cena spolu' : 'Total price'}:
    ${lang === 'sk' ? 's DPH' : 'with VAT'}: ${getPriceNumberString(order.total_paid)}
    ${lang === 'sk' ? 'bez DPH' : 'without VAT'}: ${getPriceNumberString(order.total_paid / (1 + VAT))}`
  );
}
