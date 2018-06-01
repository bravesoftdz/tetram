<template>
	<model-index
			title="Books"
			model="albums"
			:quick-search-fields="['titre_album', 'serie.titre_serie']"
			:sort-by="sortIndex"
			:group-by="groupBy"
			group-by-sort="index"
			:group-key="groupKey"
	>
		<template slot="sub-header">
			<v-layout row wrap>
				<v-flex xs6>
					<v-subheader>{{ $t('Group by') }}</v-subheader>
				</v-flex>
				<v-flex xs6>
					<v-select
							dense
							v-model="groupBy"
							:items="groups"
							item-value="key"
							item-text="name"
							single-line
					>
					</v-select>
				</v-flex>
			</v-layout>
		</template>
		<template slot="display-group" slot-scope="{ group }">
			{{ displayGroup(group) }}
		</template>
		<template slot="display-item" slot-scope="{ item }">
			{{ displayItem(item) }}
		</template>
	</model-index>
</template>

<script>
  import ModelIndex from '../../../components/ModelIndex'
  import { displayAlbum, displaySerie } from '../../../bdtheque/DisplayItem'
  import { NULL_ID } from '../../../bdtheque/GlobaleFunctions'

  export default {
    name: 'AlbumsIndex',
    components: {ModelIndex},
    data () {
      return {
        groupBy: 'serie',
        groups: [
          {key: null, name: this.$t('None')},
          {key: 'serie', name: this.$t('Serial')},
          {key: 'annee_parution', name: this.$t('Publishing year')}
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
            return item.id === NULL_ID ? `< ${this.$t('One-off')} >` : displaySerie(item)
          case 'annee_parution':
            return item[this.groupKey()] === NULL_ID ? `< ${this.$t('Unknown')} >` : item[this.groupKey()]
          default:
            return item
        }
      },
      displayItem (item) {
        return displayAlbum(item, this.groupBy !== 'serie')
      },
      groupKey () {
        switch (this.groupBy) {
          case 'annee_parution':
            return this.groupBy
          case 'serie':
          default:
            return 'id'
        }
      }
    }
  }

</script>

<style scoped>

</style>