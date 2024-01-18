// Test the convert arrow function code action.

/**
 * Run: Convert function declaration to arrow function.
 *
 * Expected result:
 * const firstTest = (one: string, two: number) => `${one} ${two}`
 */
function firstTest(one: string, two: number) {
  return `${one} ${two}`
}

/**
 * Run: Convert function declaration to arrow function.
 *
 * Expected result:
 * const secondTest = (one: string, two: number) => {
 *   console.log(one, two);
 *   return `${one} ${two}`;
 * }
 */
function secondTest(one: string, two: number) {
  console.log(one, two);
  return `${one} ${two}`;
}

/**
 * Run: Convert function declaration to arrow function.
 *
 * Expected result:
 * (one: string, two: number) => `${one} ${two}`
 */
function (one: string, two: number) {
  return `${one} ${two}`
}

/**
 * Run: Convert arrow function to function declaration.
 *
 * Expected result:
 * function fourthTest(one: string, two: number) {
 *   return `${one} ${two}`
 * }
 */
const fourthTest = (one: string, two: number) => `${one} ${two}`

/**
 * Run: Convert arrow function to function declaration.
 *
 * Expected result:
 * function fifthTest(one: string, two: number) {
 *   console.log(one, two);
 *   return `${one} ${two}`;
 * };
 */
const fifthTest = (one: string, two: number) => {
  console.log(one, two);
  return `${one} ${two}`;
};

/**
 * Run: Convert arrow function to function declaration.
 *
 * Expected result:
 * function (one: string, two: number) {
 *   return `${one} ${two}`
 * }
 */

(one: string, two: number) => `${one} ${two}`
