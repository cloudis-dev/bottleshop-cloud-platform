/* eslint-disable no-case-declarations */
/* eslint-disable @typescript-eslint/no-explicit-any */
import express from 'express';
import * as functions from 'firebase-functions';
import Stripe from 'stripe';

import { DeliveryType } from '../models/order-type';
import { tier1Region } from '../constants/other';
import { createStripeClient } from '..';
import { StripePaymentMetadata } from '../models/payment-data';
import { createOrderEffect } from '../utils/order-utils';
import { stripeWebhookSecret } from '../environment';

const app = express();

app.post('/', async (req: express.Request, res: express.Response) => {
  try {
    const stripe = createStripeClient();
    const firebaseRequest = req as functions.https.Request;
    const signature = firebaseRequest.headers['stripe-signature'] as string | string[] | Buffer;
    const event = stripe.webhooks.constructEvent(firebaseRequest.rawBody, signature, stripeWebhookSecret.value());
    const eventType: string = event.type;
    switch (eventType) {
      case 'checkout.session.completed':
        functions.logger.log('handler checkout.session.completed invoked');
        const session = event.data.object as any;
        const metadata = session.metadata as StripePaymentMetadata;
        functions.logger.log(`session data: ${JSON.stringify(session)}`);

        try {
          const orderDocId = await createOrderEffect(
            metadata.userId,
            metadata.deliveryType,
            parseInt(metadata.orderId, 10),
            metadata.orderNote,
            metadata.promoCode === undefined || metadata.promoDiscountValue === undefined
              ? undefined
              : {
                  code: metadata.promoCode,
                  discountValue: Number(metadata.promoDiscountValue),
                },
            session.amount_total / 100.0,
          );

          functions.logger.log(`checkout.session.completed ${orderDocId}`);
          return res.sendStatus(200);
        } catch (error) {
          functions.logger.error(`Order couldnt be created. Error: ${JSON.stringify(error)}`);
          return res.sendStatus(500);
        }

      case 'payment_intent.succeeded':
        functions.logger.log('handler for payment_intent.succeeded invoked');
        const data: Stripe.Event.Data = event.data;
        const pi = data.object as Stripe.PaymentIntent;
        if (!pi.metadata || !pi.metadata.userId || !pi.metadata.orderId) {
          functions.logger.error('Order couldnt be created. Incorrect metadata state.');
          return res.sendStatus(500);
        }

        const { userId, deliveryType, orderNote, orderId } = pi.metadata;
        functions.logger.log(`payment_intent.succeeded: ${userId} ${deliveryType} ${orderNote} ${orderId}`);

        try {
          const oId = createOrderEffect(
            userId,
            deliveryType as DeliveryType,
            parseInt(orderId, 10),
            orderNote,
            undefined,
            undefined,
          );
          functions.logger.log(`payment_intent.succeeded ${oId}`);
          return res.sendStatus(200);
        } catch (error) {
          functions.logger.error(`Order couldnt be created. Error: ${JSON.stringify(error)}`);
          return res.sendStatus(500);
        }

      default:
        functions.logger.warn(`handler ${eventType} invoked but ignored`);
        return res.sendStatus(400);
    }
  } catch (err) {
    functions.logger.error('Webhook failed', err);
    res.sendStatus(400);
  }
  return res.sendStatus(200);
});

export const onPaymentStatusUpdate = functions.region(tier1Region).https.onRequest(app);
