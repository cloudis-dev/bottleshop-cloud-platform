/**
 * Compare two numbers with some floating point error possible.
 * The possible error is given by the epsilon parameter.
 * @param a
 * @param b
 * @param epsilon
 * @returns
 */
export function approximately(a: number, b: number, epsilon = 0.000001): boolean {
  if (isNaN(a) || isNaN(b)) {
    return a === b;
  }
  return Math.abs(a - b) < epsilon;
}
