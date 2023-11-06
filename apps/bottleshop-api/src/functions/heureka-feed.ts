import express from 'express';
import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import { tier1Region } from '../constants/other';
import { Product } from '../models/product';
import { getProductCleanImageUrl } from '../utils/product-utils';
import { productsCollection } from '../constants/collections';
import { XMLBuilder } from 'fast-xml-parser';

const app = express();

async function createHeurekaObj(obj: Product): Promise<object> {
  const img_url = await getProductCleanImageUrl(obj);

  return {
    ITEM_ID: obj.cmat.trim(),
    PRODUCTNAME: obj.name + (obj.edition ? ' ' + obj.edition : ''),
    PRODUCT: obj.name + ' ' + 'Kuriér SR',
    DESCRIPTION: obj.description_sk,
    URL: 'https://bottleshop3veze.sk/home/products/product-detail/' + encodeURI(obj.cmat),
    IMGURL: img_url ? img_url : undefined,
    PRICE_VAT: +(obj.price_no_vat * 1.2).toFixed(2),
    CATEGORYTEXT: 'Jedlo a nápoje | Alkoholické nápoje',
    // EAN: obj.ean,
    DELIVERY_DATE: obj.amount > 0 ? 0 : 3,
    DELIVERY: {
      DELIVERY_ID: 'DPD',
      DELIVERY_PRICE: 5,
      DELIVERY_PRICE_COD: 5,
    },
  };
}

async function createXMLFeed(products: Product[]): Promise<string> {
  const builder = new XMLBuilder({
    arrayNodeName: 'SHOP',
    format: true,
  });

  return (
    '<?xml version="1.0" encoding="utf-8"?>\n' +
    builder.build([
      {
        SHOPITEM: await Promise.all(products.map((prod) => createHeurekaObj(prod))),
      },
    ])
  );
}

app.get('/', async (req: express.Request, res: express.Response) => {
  const products = await admin
    .firestore()
    .collection(productsCollection)
    .get()
    .then(async (snap) => snap.docs.map((doc) => doc.data() as Product).filter((prod) => prod.amount > 0));

  const feed = await createXMLFeed(products);
  return res.send(feed);
});

export const heurekaXmlFeed = functions.region(tier1Region).runWith({ memory: '1GB' }).https.onRequest(app);
