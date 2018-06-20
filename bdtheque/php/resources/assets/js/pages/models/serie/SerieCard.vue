<template>
	<model-card title="Série">
		<v-layout column justify-start>
			<v-flex id="titre">
				{{ $formatTitre(item.titre_serie) }}
			</v-flex>
			<v-flex id="editeur" v-if="item.editeur">
				{{ $formatTitre(item.editeur.nom_editeur) }}
			</v-flex>
			<v-flex id="collection" v-if="item.collection">
				{{ $formatTitre(item.collection.nom_collection) }}
			</v-flex>
			<v-flex id="etat" v-if="item.terminee">
				{{ item.terminee ? `Terminée` : `En cours` }}
			</v-flex>
			<v-flex id="univers">
				<model-display-list model-display="univers-display" :items="item.univers"/>
			</v-flex>
			<v-flex id="genres">
				<model-display-list model-display="genre-display" :items="item.genres"/>
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
			<v-flex id="album" v-for="album in item.albums" :key="album.id">
				<router-link :to="$itemRoute('album.card', album)">
					{{ $formatTitreAlbum(false, false, album.titre_album, null, album.tome, album.tome_debut, album.tome_fin, album.integrale, album.hors_serie) }}
				</router-link>
			</v-flex>
		</v-layout>
	</model-card>
</template>

<script>
  import ModelCard from '../../../components/ModelCard'
  import TemplateCard from '../ModelCard'
  import ModelDisplayList from '../ModelDisplayList'

  export default {
    name: 'SerieCard',
    extends: TemplateCard,
    components: {ModelDisplayList, ModelCard},
    data: () => ({
      model: 'series'
    }),
  }
</script>

<style scoped>

</style>