import { ajoutString, formatISBN, formatTitre, formatTitreAlbum, nonZero } from './GlobaleFunctions'

/**
 * @param {Album} album
 * @param {Boolean} withSerie
 * @returns {string}
 */
export function displayAlbum (album, withSerie = true) {
  return formatTitreAlbum(
    false,
    withSerie,
    album.titre_album,
    album.serie ? album.serie.titre_serie : null,
    album.tome,
    album.tome_debut,
    album.tome_fin,
    album.integrale,
    album.hors_serie
  )
}

/**
 * @param {Serie} serie
 * @param {Boolean} simple
 * @returns {string}
 */
export function displaySerie (serie, simple = false) {
  const result = simple ? serie.titre_serie : formatTitre(serie.titre_serie)
  let s = ''
  s = ajoutString(s, serie.editeur ? formatTitre(serie.editeur.nom_editeur) : '', ' ')
  s = ajoutString(s, serie.collection ? formatTitre(serie.collection.nom_collection) : '', ' - ')

  return ajoutString(result, s, ' ', '(', ')')
}

/**
 * @param {Univers} univers
 * @return {string}
 */
export function displayUnivers (univers) {
  return formatTitre(univers.nom_univers)
}

/**
 * @param {Editeur} editeur
 * @return {string}
 */
export function displayEditeur (editeur) {
  return formatTitre(editeur.nom_editeur)
}

/**
 * @param {Personne} author
 * @return {string}
 */
export function displayAuthor (author) {
  return formatTitre(author.nom_personne)
}

/**
 * @param {Collection} collection
 * @param {Boolean} simple
 * @return {string}
 */
export function displayCollection (collection, simple = false) {
  let s = formatTitre(collection.nom_collection)
  if (!simple) s = ajoutString(s, formatTitre(collection.editeur.nom_editeur), ' ', '(', ')')
  return s
}

/**
 * @param {Edition} edition
 * @return {string}
 */
export function displayEdition (edition) {
  let result = ''
  result = ajoutString(result, formatTitre(edition.editeur.nom_editeur), ' ')
  result = ajoutString(result, formatTitre(edition.collection.nom_collection), ' ', '(', ')')
  result = ajoutString(result, nonZero(edition.annee_edition.toString()), ' ', '[', ']')
  result = ajoutString(result, formatISBN(edition.isbn), ' - ', 'ISBN ')
  return result
}

/**
 * @param {Genre} genre
 * @return {string}
 */
export function displayGenre (genre) {
  return genre.genre
}

/**
 * @param {ParaBd} parabd
 * @param {Boolean} simple
 * @param {Boolean} avecSerie
 * @return {string}
 */
export function displayParaBd (parabd, simple = false, avecSerie = false) {
  let result = simple ? parabd.titre_para_bd : formatTitre(parabd.titre_para_bd)

  let s = ''
  if (avecSerie) {
    if (result === '') {
      result = formatTitre(parabd.serie.titre_serie)
    } else {
      s = ajoutString(s, formatTitre(parabd.serie.titre_serie), ' - ')
    }
  }
  // TODO: handle categories' name
  // ajoutString(s, sCategorie, ' - ');

  return result === '' ? s : ajoutString(result, s, ' ', '(', ')')
}
