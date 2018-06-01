export const NULL_ID = '<null>'

/**
 * @param {string} s
 * @returns {string}
 */
export function trans (s) {
  return window.VueInstance.$t(s)
}

/**
 * @param {string} titre
 * @returns {string}
 */
export function formatTitre (titre) {
  if (!titre) return ''
  const i = titre.lastIndexOf('[')
  if (i > -1) {
    const j = titre.lastIndexOf(']')
    if (j > i) {
      let article = titre.substring(i + 1, j).trim()
      if (!article.endsWith('\'')) article += ' '
      return article + titre.substring(0, i - 1).trim()
    }
  }
  return titre.trim()
}

/**
 * @param {boolean} simple
 * @param {boolean} avecSerie
 * @param {string|null} titre
 * @param {string|null} serie
 * @param {Number|null} tome
 * @param {Number|null} tomeDebut
 * @param {Number|null} tomeFin
 * @param {boolean|null} integrale
 * @param {boolean|null} horsSerie
 * @returns {string}
 */
export function formatTitreAlbum (simple, avecSerie, titre, serie, tome, tomeDebut, tomeFin, integrale, horsSerie) {
  let titreAlbum = simple ? titre.trim() : formatTitre(titre)
  let titreSerie = ''
  if (avecSerie) {
    if (!titreAlbum) {
      titreAlbum = formatTitre(serie)
    } else {
      titreSerie = formatTitre(serie)
    }
  }

  let num = ''
  if (integrale) {
    let dummy = nonZero(tomeDebut)
    dummy = ajoutString(dummy, nonZero(tomeFin), trans(' to '))
    num = ajoutString(num, trans(titreAlbum ? 'Full' : 'F.'), ' - ', '', rtrim(' ' + nonZero(tome)))
    num = ajoutString(num, dummy, ' ', '[', ']')
  } else if (horsSerie) {
    num = ajoutString(num, trans(titreAlbum ? 'One-off' : 'OO'), ' - ', '', rtrim(' ' + nonZero(tome)))
  } else {
    num = ajoutString(num, nonZero(tome), ' - ', titreAlbum ? trans('Volume') + ' ' : trans('Vol.'))
  }

  let result
  // switch (formatTitreAlbum) {
  //   case 1: {
  //     // Tome - Album (Serie)
  //     titreAlbum = titreAlbum ? ajoutString(titreAlbum, titreSerie, ' ', '(', ')') : titreSerie
  //     result = ajoutString(num, titreAlbum, ' - ')
  //     break
  //   }
  //   case 0:
  //   default: {
  // Album (Serie - Tome)
  titreSerie = ajoutString(titreSerie, num, ' - ')
  result = titreAlbum ? ajoutString(titreAlbum, titreSerie, ' ', '(', ')') : titreSerie
  //   }
  // }

  if (result === '') result = trans('<No title>')
  return result
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

export function formatISBN (s) {
  // TODO: to implement
  return s
}
