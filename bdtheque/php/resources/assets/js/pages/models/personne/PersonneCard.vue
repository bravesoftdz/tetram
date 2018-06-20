<template>
	<model-card title="Auteur">
		<v-layout column justify-start>
			<v-flex id="nom">
				{{ $formatTitre(item.nom_personne) }}
			</v-flex>
			<v-flex id="biographie">
				{{ item.biographie }}
			</v-flex>
			<v-flex id="bibliographie">
				<model-tree
						v-if="item.id"
						model="albums"
						group-by="serie"
						:sort-by="sortIndex"
						:defaultFilter="bibliographieFilter(item)"
						compact
						:key="item.id"
				>
					<template slot="display-group" slot-scope="{ group }">
						{{ displayGroup(group) }}
						<model-notation :value="group.notation"/>
					</template>
					<template slot="display-item" slot-scope="{ item }">
						<router-link :to="$itemRoute('album.card', item)">{{ $displayAlbum(item, false) }}</router-link>
						<model-notation :value="item.notation"/>
					</template>
				</model-tree>
			</v-flex>
		</v-layout>
	</model-card>
</template>

<script>
  import ModelCard from '../../../components/ModelCard'
  import TemplateCard from '../ModelCard'
  import ModelTree from '../../../components/ModelTree'
  import ModelNotation from '../../../components/ModelNotation'
  import { NULL_ID } from '../../../mixins/global/API'

  export default {
    name: 'PersonneCard',
    extends: TemplateCard,
    components: {ModelNotation, ModelTree, ModelCard},
    data: () => ({
      model: 'authors'
    }),
    methods: {
      sortIndex (item) {
        return (item && (item !== NULL_ID)) ? 'subindex' : 'index'
      },
      displayGroup (item) {
        return item.id === NULL_ID ? `< Hors-série >` : this.$displaySerie(item)
      },
      bibliographieFilter (auteur) {
        return [
          {
            column: 'id',
            comparison: 'in',
            value: Array.from(auteur.albums, (album) => album.id)
          }
        ]
      }
    }
  }
</script>

<style scoped>

</style>