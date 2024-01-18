// Test the flip ternary code action.

/**
 * Run: Flip ternary.
 *
 * Expected result:
 * const firstTest = false ? 'no' : 'yes';
 */
const firstTest = true ? 'yes' : 'no';

/**
 * Run: Flip ternary.
 *
 * Expected result:
 * const secondTest = !(1 + 1 === 2) ? 'no' : 'yes';
 */
const secondTest = 1 + 1 === 2 ? 'yes' : 'no';

/**
 * Run: Flip ternary.
 *
 * Expected result:
 * const thirdTest = !(1 + 1 === 2) ? (
 *   2 + 2 === 4 ? 'yes' : 'no'
 * ) : 'yes';
 */
const thirdTest = 1 + 1 === 2 ? 'yes' : (
  2 + 2 === 4 ? 'yes' : 'no'
);

/**
 * Run: Flip ternary.
 *
 * Expected result:
 * const firstTest = true ? 'yes' : 'no';
 */
const fourthTest = !(true) ? 'no' : 'yes';

/**
 * Run: Flip ternary.
 *
 * Expected result:
 * const secondTest = 1 + 1 === 2 ? 'yes' : 'no';
 */
const fifthTest = !(1 + 1 === 2) ? 'no' : 'yes';

/**
 * Run: Flip ternary.
 *
 * Expected result:
 * const sixthTest = 1 + 1 === 2 ? 'yes' : (
 *   2 + 2 === 4 ? 'yes' : 'no'
 * );
 */
const sixthTest = !(1 + 1 === 2) ? (
  2 + 2 === 4 ? 'yes' : 'no'
) : 'yes';
