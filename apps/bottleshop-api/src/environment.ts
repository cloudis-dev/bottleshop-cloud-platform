import { defineString } from 'firebase-functions/params';

export const stripeSecretKey = defineString('STRIPE_SECRET_KEY');
export const stripeWebhookSecret = defineString('STRIPE_WEBHOOK_SECRET');
export const algoliaApiKey = defineString('ALGOLIA_API_KEY');
