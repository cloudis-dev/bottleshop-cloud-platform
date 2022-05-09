import { DateTime } from 'luxon';

/**
 * Format date to the local format in SK.
 * @param date
 * @returns
 */
export function formatDate(date: Date): string {
  return DateTime.fromJSDate(date).toFormat('dd.LL.yyyy hh:mm:ss');
}
