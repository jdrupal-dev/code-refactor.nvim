// Test the toggle arrow function braces code action.

/**
 * Run: Remove braces from arrow function.
 *
 * Expected result:
 * const firstTest = (params: object) => params
 */
const firstTest = (params: object) => {
  return params;
}

/**
 * Remove braces from arrow function should not change the code.
 * TODO: The code action shold not appear when it doesn't do anything.
 */
const secondTest = (params: object) => {
  console.log(params);
  return params;
}


/**
 * Run: Remove braces from arrow function.
 *
 * Expected result:
 * const thirdTest = () => (
 *   [
 *    'first',
 *    'second'
 *  ]
 * )
 */
const thirdTest = () => {
  return (
    [
      'first',
      'second'
    ]
  );
}

/**
 * Run: Add braces to arrow function.
 *
 * Expected result:
 * const firstTest = (params: object) => {
 *   return params;
 * };
 */
const firstTest = (params: object) => params;

/**
 * Run: Add braces to arrow function.
 *
 * Expected result:
 * const thirdTest = () => {
 *   return (
 *     [
 *       'first',
 *       'second'
 *     ]
 *   );
 * }
 */
const thirdTest = () => (
  [
    'first',
    'second'
  ]
)
