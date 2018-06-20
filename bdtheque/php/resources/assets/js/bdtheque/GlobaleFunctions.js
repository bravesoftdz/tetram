/**
 * @param {string} s
 * @returns {Vue}
 */
export function getVueInstance (s) {
  return window.VueInstance
}

/**
 * @param {string|Number} value
 * @returns {string}
 */
export function nonZero (value) {
  if (!value || value === '0' || value === 0) return ''
  return value.toString()
}

/**
 * @param {string} chaine
 * @param {string} ajout
 * @param {string} espace
 * @param {string} avant
 * @param {string} apres
 * @returns {string}
 */
export function ajoutString (chaine, ajout, espace, avant = '', apres = '') {
  let add = ajout
  if (ajout) {
    add = avant + ajout + apres
    if (chaine) chaine += espace
  }
  return chaine + add
}

/**
 * @param {string} s
 * @returns {string}
 */
export function rtrim (s) {
  for (let i = s.length - 1; i >= 0; i--) {
    if (s.charAt(i) !== ' ') return s.substring(0, i + 1)
  }
  return s
}
