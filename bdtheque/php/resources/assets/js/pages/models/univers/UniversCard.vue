<template>
	<model-card title="Univers">
		<v-layout column justify-start>
			<v-flex id="nom">
				{{ $formatTitre(item.nom_univers) }}
			</v-flex>
			<v-flex id="parent" v-if="item.univers_parent">
				<router-link :to="$itemRoute('univers.card', item.univers_parent)">{{
					$formatTitre(item.univers_parent.nom_univers) }}
				</router-link>
			</v-flex>
			<v-flex id="racine" v-if="item.univers_racine && (item.univers_racine.id !== item.univers_parent.id)">
				<router-link :to="$itemRoute('univers.card', item.univers_racine)">{{
					$formatTitre(item.univers_racine.nom_univers) }}
				</router-link>
			</v-flex>
			<v-flex id="description">
				{{ item.description }}
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
					<span slot="display-group" slot-scope="{ group }">
						{{ displayGroup(group) }}
					</span>
					<router-link slot="display-item" slot-scope="{ item }" :to="$itemRoute('album.card', item)">
						{{ $displayAlbum(item, false) }}
					</router-link>
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
    name: 'UniversCard',
    extends: TemplateCard,
    components: {ModelNotation, ModelTree, ModelCard},
    data: () => ({
      model: 'univers'
    }),
    methods: {
      sortIndex (item) {
        return (item && (item !== NULL_ID)) ? 'subindex' : 'index'
      },
      displayGroup (item) {
        return item.id === NULL_ID ? `< Hors-série >` : this.$displaySerie(item)
      },
      bibliographieFilter (univers) {
        return [
          {
            column: 'id',
            comparison: 'in',
            value: Array.from(univers.albums, (album) => album.id)
          }
        ]
      }
    }
  }
</script>

<style scoped>

</style>