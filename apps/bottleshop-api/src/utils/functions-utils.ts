import { FirebaseConfig } from '../models/firebase-config';

/**
 * Check if the the functions are running in an emulator or not.
 * @returns
 */
export function isEmulator(): boolean {
  return process.env.FUNCTIONS_EMULATOR === 'true';
}

export function isTestEnv(): boolean {
  const FIREBASE_CONFIG: FirebaseConfig = JSON.parse(process.env.FIREBASE_CONFIG as string);
  return FIREBASE_CONFIG.projectId.includes('dev');
}

export function isProdEnv(): boolean {
  return !isTestEnv();
}
