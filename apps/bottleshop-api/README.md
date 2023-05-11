# Bottleshop API

Configuration from Firebase modules. Contains code for Firebase Function, too.

# Setup

1. Install Firebase CLI: https://firebase.google.com/docs/cli (or via `npm install -g firebase-tools`)
2. Install Stripe CLI: https://stripe.com/docs/stripe-cli
3. Have Java runtime installed
4. Login to the Firebase CLI (`firebase login`) and [select correct project](#firebase-projects).
5. Login to the Stripe CLI (`stripe login`)
6. Add seed to `apps/bottleshop-api/firebase-seed` (ask for this directory the other devs)


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


### Steps before deploy

1. Check that you have at least `firebase-tools` v11.25.3 (ie. `firebase --version`). It's important so the env variables are properly uploaded during deployment.
2. Create .env.{project ID} file with all the necessary env variables (eg. `.env.bottleshop-3-veze-dev-54908`). You will be automatically notified of the missing env variables in case you have the right version of `firebase-tools`. Here's the documentation related to the env variables https://firebase.google.com/docs/functions/config-env

### Deploy only functions

`firebase deploy --only functions`

### Firestore rules

`npm run deploy:firestore:rules`

The rules are stored in the file `./firestore.rules`

### Firebase Storage

**CORS configuration:**

`npm run deploy:storage:cors`

The CORS configuration is stored in the file `./storage.cors.json`