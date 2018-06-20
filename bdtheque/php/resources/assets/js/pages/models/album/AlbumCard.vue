<template>
	<model-card title="Album">
		<template slot="media">

		</template>
		<v-layout column justify-start>
			<v-flex id="titre">
				{{ $formatTitre(item.titre_album) }}
			</v-flex>
			<v-flex v-if="item.serie" id="serie">
				<router-link :to="$itemRoute('serie.card', item.serie)">
					{{ $formatTitre(item.serie.titre_serie) }}
				</router-link>
			</v-flex>
			<v-flex id="tome">
				{{ $displayTome(item) }}
			</v-flex>
			<v-flex id="parution">
				{{ $displayParution(item) }}
			</v-flex>
			<v-flex id="univers">
				<model-display-list model-display="univers-display" :items="item.univers"/>
			</v-flex>
			<v-flex id="genres">
				<model-display-list model-display="genre-display" :items="item.serie ? item.serie.genres : item.genres"/>
			</v-flex>
			<v-flex id="scenaristes">
				<model-display-list
						model-display="personne-display"
						:items="item.scenaristes"
						route-name="auteur.card"
				/>
			</v-flex>
			<v-flex id="dessinateurs">
				<model-display-list
						model-display="personne-display"
						:items="item.dessinateurs"
						route-name="auteur.card"
				/>
			</v-flex>
			<v-flex id="coloristes">
				<model-display-list
						model-display="personne-display"
						:items="item.coloristes"
						route-name="auteur.card"
				/>
			</v-flex>
			<v-flex id="sujet">
				{{ item.sujet }}
			</v-flex>
			<v-flex id="notes">
				{{ item.notes }}
			</v-flex>
			<v-flex id="edition" v-for="edition in item.editions" :key="edition.id">
				<v-flex id="isbn">
					{{ edition.formatted_isbn }}
				</v-flex>
				<v-flex id="editeur" v-if="edition.editeur">
					{{ $formatTitre(edition.editeur.nom_editeur) }}
				</v-flex>
				<v-flex id="collection" v-if="edition.collection">
					{{ $formatTitre(edition.collection.nom_collection) }}
				</v-flex>
				<v-flex id="prix">
					<template v-if="edition.gratuit">
						<template v-if="!edition.offert">
							Gratuit
						</template>
					</template>
					<template v-else-if="edition.prix">{{ $formatPrix(edition.prix) }}</template>
				</v-flex>
				<v-flex id="dateAchat">
					{{ $formatDate(edition.date_achat) }}
				</v-flex>
				<v-flex id="etat" v-if="edition.etat">
					{{ $displayEnum(`etat`, edition.etat) }}
				</v-flex>
				<v-flex id="reliure" v-if="edition.reliure">
					{{ $displayEnum('reliure', edition.reliure) }}
				</v-flex>
				<v-flex id="type_edition" v-if="edition.type_edition">
					{{ $displayEnum('type_edition', edition.type_edition) }}
				</v-flex>
				<v-flex id="orientation" v-if="edition.orientation">
					{{ $displayEnum('orientation', edition.orientation) }}
				</v-flex>
				<v-flex id="format_edition" v-if="edition.format_edition">
					{{ $displayEnum('format_edition', edition.format_edition) }}
				</v-flex>
				<v-flex id="sens_lecture" v-if="edition.sens_lecture">
					{{ $displayEnum('sens_lecture', edition.sens_lecture) }}
				</v-flex>
			</v-flex>
		</v-layout>
	</model-card>
</template>

<script>
  import ModelCard from '../../../components/ModelCard'
  import TemplateCard from '../ModelCard'
  import ModelDisplayList from '../ModelDisplayList'

  export default {
    name: 'AlbumCard',
    extends: TemplateCard,
    components: {ModelDisplayList, ModelCard},
    data: () => ({
      model: 'albums'
    }),
  }
</script>

<style scoped>

</style>