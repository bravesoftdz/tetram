import { ajoutString, nonZero, rtrim } from '../../bdtheque/GlobaleFunctions'

export default {
  methods: {
    /**
     * @param {Album} album
     * @param {Boolean} withSerie
     * @returns {string}
     */
    $displayAlbum (album, withSerie = true) {
      return this.$formatTitreAlbum(
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
    },

    /**
     * @param {Serie} serie
     * @param {Boolean} simple
     * @returns {string}
     */
    $displaySerie (serie, simple = false) {
      const result = simple ? serie.titre_serie : this.$formatTitre(serie.titre_serie)
      let s = ''
      s = ajoutString(s, serie.editeur ? this.$formatTitre(serie.editeur.nom_editeur) : '', ' ')
      s = ajoutString(s, serie.collection ? this.$formatTitre(serie.collection.nom_collection) : '', ' - ')

      return ajoutString(result, s, ' ', '(', ')')
    },

    /**
     * @param {Univers} univers
     * @return {string}
     */
    $displayUnivers (univers) {
      return this.$formatTitre(univers.nom_univers)
    },

    /**
     * @param {Editeur} editeur
     * @return {string}
     */
    $displayEditeur (editeur) {
      return this.$formatTitre(editeur.nom_editeur)
    },

    /**
     * @param {Personne} author
     * @return {string}
     */
    $displayAuthor (author) {
      return this.$formatTitre(author.nom_personne)
    },

    /**
     * @param {Collection} collection
     * @param {Boolean} simple
     * @return {string}
     */
    $displayCollection (collection, simple = false) {
      let s = this.$formatTitre(collection.nom_collection)
      if (!simple) s = ajoutString(s, this.$formatTitre(collection.editeur.nom_editeur), ' ', '(', ')')
      return s
    },

    /**
     * @param {Edition} edition
     * @return {string}
     */
    $displayEdition (edition) {
      let result = ''
      result = ajoutString(result, this.$formatTitre(edition.editeur.nom_editeur), ' ')
      result = ajoutString(result, this.$formatTitre(edition.collection.nom_collection), ' ', '(', ')')
      result = ajoutString(result, nonZero(edition.annee_edition.toString()), ' ', '[', ']')
      result = ajoutString(result, edition.formatted_isbn, ' - ', 'ISBN ')
      return result
    },

    /**
     * @param {Genre} genre
     * @return {string}
     */
    $displayGenre (genre) {
      return genre.genre
    },

    /**
     * @param {ParaBd} parabd
     * @param {Boolean} simple
     * @param {Boolean} avecSerie
     * @return {string}
     */
    $displayParaBd (parabd, simple = false, avecSerie = false) {
      let result = simple ? parabd.titre_para_bd : this.$formatTitre(parabd.titre_para_bd)

      let s = ''
      if (avecSerie) {
        if (result === '') {
          result = this.$formatTitre(parabd.serie.titre_serie)
        } else {
          s = ajoutString(s, this.$formatTitre(parabd.serie.titre_serie), ' - ')
        }
      }
      // TODO: handle categories' name
      // ajoutString(s, sCategorie, ' - ');

      return result === '' ? s : ajoutString(result, s, ' ', '(', ')')
    },

    /**
     * @param {Album} album
     * @returns {String}
     */
    $displayParution (album) {
      if (!album.annee_parution) return ''
      if (!album.mois_parution) return album.annee_parution.toString()
      const result = this.$moment(new Date(album.annee_parution, album.mois_parution - 1)).format(`MMM YYYY`)
      return result.charAt(0).toLocaleUpperCase() + result.slice(1)
    },

    /**
     * @param {Album} album
     * @returns {String}
     */
    $displayTome (album) {
      if (album.hors_serie) return `Hors-série` + rtrim(` ` + nonZero(album.tome))
      if (album.integrale) {
        let s = ajoutString(nonZero(album.tome_debut), nonZero(album.tome_fin), ` à `)
        return ajoutString(`Intégrale` + rtrim(` ` + nonZero(album.tome)), s, ` `, `[`, `]`)
      }
      return nonZero(album.tome_fin)
    },

    /**
     * @param {Serie} serie
     * @returns {String}
     */
    $displayGenres (serie) {
      if (!(serie && serie.genres)) return ''
      return serie.genres.map(g => g.genre).join(`, `)
    },

    /**
     * @param {[Personne]} auteurs
     * @param route
     * @returns {string}
     */
    $displayAuteurs (auteurs, route = 'auteur.card') {
      if (!auteurs || auteurs.length === 0) return ''
      return auteurs
        .map(a => this.$createElement(
          'router-link',
          {
            props: {
              to: this.$itemRoute(route, a)
            }
          },
          this.$formatTitre(a.nom_personne)
        ))
        .join(`, `)
    },

    /**
     * @param {string} titre
     * @returns {string}
     */
    $formatTitre (titre) {
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
    },

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
    $formatTitreAlbum (simple, avecSerie, titre, serie, tome, tomeDebut, tomeFin, integrale, horsSerie) {
      let titreAlbum = simple ? titre.trim() : this.$formatTitre(titre)
      let titreSerie = ''
      if (avecSerie) {
        if (!titreAlbum) {
          titreAlbum = this.$formatTitre(serie)
        } else {
          titreSerie = this.$formatTitre(serie)
        }
      }

      let num = ''
      if (integrale) {
        let dummy = nonZero(tomeDebut)
        dummy = ajoutString(dummy, nonZero(tomeFin), ' à ')
        num = ajoutString(num, titreAlbum ? 'Intégrale' : 'Int.', ' - ', '', rtrim(' ' + nonZero(tome)))
        num = ajoutString(num, dummy, ' ', '[', ']')
      } else if (horsSerie) {
        num = ajoutString(num, titreAlbum ? 'Hors-série' : 'HS', ' - ', '', rtrim(' ' + nonZero(tome)))
      } else {
        num = ajoutString(num, nonZero(tome), ' - ', titreAlbum ? 'Tome' + ' ' : 'T.')
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

      if (result === '') result = '< Sans titre >'
      return result
    },

    /**
     * @param {string|Number} value
     * @returns {string}
     */
    $nonZero (value) {
      return nonZero(value)
    },

    /**
     * @param {string} enumTag
     * @param {Number} value
     * @returns {string}
     */
    $displayEnum (enumTag, value) {
      return this.$t(`enum.${enumTag}.${value}`)
    },

    $formatPrix (prix) {
      return new Intl.NumberFormat(this.$i18n.locale, {style: 'currency', currency: 'EUR'}).format(prix)
    },

    /**
     * @param date
     * @param {Boolean} numeric
     * @returns {*}
     */
    $formatDate (date, numeric = false) {
      if ((date !== null) && (typeof date === 'object')) date = this.$Carbon2Moment(date)
      return date !== null ? this.$moment(date).format(numeric ? `L` : `ll`) : ''
    }
  }
}
