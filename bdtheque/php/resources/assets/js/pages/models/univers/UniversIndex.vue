<template>
	<model-index
			title="Univers"
			model="univers"
			quick-search-fields="nom_univers"
			sort-by="index"
			:group-by="groupBy"
			group-key="id"
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
			{{ displayItem(group) }}
		</template>
		<template slot="display-item" slot-scope="{ item }">
			{{ displayItem(item) }}
		</template>
	</model-index>
</template>

<script>
  import ModelIndex from '../../../components/ModelIndex'
  import { displayUnivers } from '../../../bdtheque/DisplayItem'
  import { NULL_ID } from '../../../bdtheque/GlobaleFunctions'

  export default {
    name: 'UniversIndex',
    components: {ModelIndex},
    data () {
      return {
        groupBy: null,
        groups: [
          {key: null, name: 'Pas de groupe'},
          {key: 'univers_parent', name: 'Univers parent'},
          {key: 'univers_racine', name: 'Univers racine'},
        ]
      }
    },
    methods: {
      /**
       * @param {Univers} item
       * @returns {*}
       */
      displayItem (item) {
        switch (this.groupBy) {
          case 'univers_parent':
            return item.id === NULL_ID ? `< Pas de parent >` : displayUnivers(item)
          case 'univers_racine':
            return item.id === NULL_ID ? `< Pas de racine >` : displayUnivers(item)
          default:
            return displayUnivers(item)
        }
      },
    }
  }
</script>

<style scoped>

</style>