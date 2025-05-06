/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS205: Consider reworking code to avoid use of IIFEs
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
window.ordinal = function(number) {
  const digit = number % 10;
  const teens = number % 100;

  const suffix = (() => { switch (false) {
    case (digit !== 1) || (teens === 11): return 'st';
    case (digit !== 2) || (teens === 12): return 'nd';
    case (digit !== 3) || (teens === 13): return 'rd';
    default: return 'th';
  } })();

  return `${number}${suffix}`;
};
