<template>
	<model-tree
			title="Albums"
			model="albums"
			:quick-search-fields="['titre_album', 'serie.titre_serie']"
			:sort-by="sortIndex"
			:group-by="groupBy"
			group-by-sort="index"
			:group-key="groupKey"
	>
		<v-flex slot="sub-header">
			<v-layout row align-baseline>
				<v-flex>
					Grouper par
				</v-flex>
				<v-flex>
					<v-select
							dense
							v-model="groupBy"
							:items="groups"
							item-value="key"
							item-text="name"
							single-line
							hide-details
					>
					</v-select>
				</v-flex>
			</v-layout>
		</v-flex>
		<template slot="display-group" slot-scope="{ group }">
			{{ displayGroup(group) }}
			<model-notation :value="group.notation"/>
		</template>
		<template slot="display-item" slot-scope="{ item }">
			<router-link :to="$itemRoute(routeName, item)">
				{{ $displayAlbum(item, this.groupBy !== 'serie') }}
			</router-link>
			<model-notation :value="item.notation"/>
		</template>
	</model-tree>
</template>

<script>
  import ModelIndex from '../ModelIndex'
  import ModelTree from '../../../components/ModelTree'
  import ModelNotation from '../../../components/ModelNotation'
  import { NULL_ID } from '../../../mixins/global/API'

  export default {
    name: 'AlbumsIndex',
    extends: ModelIndex,
    components: {ModelNotation, ModelTree},
    props: {
      routeName: {default: 'album.card'}
    },
    data () {
      return {
        groupBy: 'serie',
        groups: [
          {key: null, name: 'Pas de groupe'},
          {key: 'initiale_titre_album', name: 'Initiale du titre'},
          {key: 'serie', name: 'Série'},
          {key: 'annee_parution', name: 'Année de parution'}
        ]
      }
    },
    methods: {
      sortIndex (item) {
        return ((this.groupBy === 'serie') && item && (item !== NULL_ID)) ? 'subindex' : 'index'
      },
      /**
       * @param {Album|Serie} item
       * @returns {*}
       */
      displayGroup (item) {
        switch (this.groupBy) {
          case 'serie':
            return item.id === NULL_ID ? `< Hors-série >` : this.$displaySerie(item)
          case 'annee_parution':
            return item[this.groupKey()] === NULL_ID ? `< Inconnue >` : item[this.groupKey()]
          default:
            return item[this.groupKey()] === NULL_ID ? `< Inconnu >` : item[this.groupKey()]
        }
      },
      displayItem (item) {
        return this.$displayAlbum(item, this.groupBy !== 'serie')
      },
      groupKey () {
        switch (this.groupBy) {
          case 'serie':
            return 'id'
          default:
            return this.groupBy
        }
      }
    }
  }

</script>

<style scoped>

</style>