# Bottleshop API

Configuration from Firebase modules. Contains code for Firebase Function, too.

# Setup

1. Install Firebase CLI: https://firebase.google.com/docs/cli
2. Install Stripe CLI: https://stripe.com/docs/stripe-cli
3. Have Java runtime installed
4. Login to the Firebase CLI (`firebase login`) and [select correct project](#firebase-projects).
5. Login to the Stripe CLI (`stripe login`)
6. Sync firebase env config: `firebase functions:config:get > .runtimeconfig.json`. Location: `apps/bottleshop-api/.runtimeconfig.json`
7. Add seed to `apps/bottleshop-api/firebase-seed` (ask for this directory the other devs)


# Switching environments<a id='firebase-projects'></a>

You can see all available projects using `firebase projects:list` CLI command or in the `.firebaserc` file.

To switch use the `firebase use [alias]` CLI command where alias is the key in the `.firebaserc` file. To see actively selected project run `firebase use` CLI command.

# Other

## Indexes

The file `firestore.indexes.json` is taken into account.
To update it with data stored in the firebase run `firebase firestore:indexes > firestore.indexes.json`.

This file is uploaded on the deploy.

## Debugging
To check if running in an emulator use `process.env.FUNCTIONS_EMULATOR === 'true'`

## Deploying

### Firestore rules

`npm run deploy:firestore:rules`

The rules are stored in the file `./firestore.rules`

### Firebase Storage

**CORS configuration:**

`npm run deploy:storage:cors`

The CORS configuration is stored in the file `./storage.cors.json`