<template>
	<model-tree
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
			<router-link :to="$itemRoute(routeName, item)">{{ displayItem(item) }}</router-link>
		</template>
	</model-tree>
</template>

<script>
  import ModelIndex from '../ModelIndex'
  import ModelTree from '../../../components/ModelTree'
  import { NULL_ID } from '../../../mixins/global/API'

  export default {
    name: 'UniversIndex',
    extends: ModelIndex,
    props: {
      routeName: {default: 'univers.card'}
    },
    components: {ModelTree},
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
            return item.id === NULL_ID ? `< Pas de parent >` : this.$displayUnivers(item)
          case 'univers_racine':
            return item.id === NULL_ID ? `< Pas de racine >` : this.$displayUnivers(item)
          default:
            return this.$displayUnivers(item)
        }
      },
    }
  }
</script>

<style scoped>

</style>