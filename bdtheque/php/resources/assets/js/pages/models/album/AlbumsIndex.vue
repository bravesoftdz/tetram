<template>
	<model-index
			title="Albums"
			model="albums"
			:quick-search-fields="['titre_album', 'serie.titre_serie']"
			:sort-by="sortIndex"
			:group-by="groupBy"
			group-by-sort="index"
			:group-key="groupKey"
	>
		<template slot="sub-header">
			<v-flex>
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
		</template>
		<template slot="display-group" slot-scope="{ group }">
			<v-layout row>
				{{ displayGroup(group) }}
				<template v-if="group.notation">
					<v-spacer/>
					<model-notation align-right :value="group.notation" class="shrink"></model-notation>
				</template>
			</v-layout>
		</template>
		<template slot="display-item" slot-scope="{ item }">
			<v-layout row>
				{{ displayItem(item) }}
				<v-spacer/>
				<model-notation align-right :value="item.notation" class="shrink"></model-notation>
			</v-layout>
		</template>
	</model-index>
</template>

<script>
  import ModelIndex from '../../../components/ModelIndex'
  import { displayAlbum, displaySerie } from '../../../bdtheque/DisplayItem'
  import { NULL_ID } from '../../../bdtheque/GlobaleFunctions'
  import ModelNotation from '../../../components/ModelNotation'

  export default {
    name: 'AlbumsIndex',
    components: {ModelNotation, ModelIndex},
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
            return item.id === NULL_ID ? `< Hors-série >` : displaySerie(item)
          case 'annee_parution':
            return item[this.groupKey()] === NULL_ID ? `< Inconnue >` : item[this.groupKey()]
          default:
            return item[this.groupKey()] === NULL_ID ? `< Inconnu >` : item[this.groupKey()]
        }
      },
      displayItem (item) {
        return displayAlbum(item, this.groupBy !== 'serie')
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