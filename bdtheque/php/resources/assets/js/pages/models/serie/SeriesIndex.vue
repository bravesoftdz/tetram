<template>
	<model-tree
			title="Séries"
			model="series"
			quick-search-fields="titre_serie"
			sort-by="index"
	>
		<template slot="display-item" slot-scope="{ item }">
			<v-layout row>
				{{ displayItem(item) }}
				<v-spacer/>
				<model-notation align-right :value="item.notation" class="shrink"></model-notation>
			</v-layout>
		</template>
	</model-tree>
</template>

<script>
  import ModelIndex from '../ModelIndex'
  import ModelTree from '../../../components/ModelTree'
  import { displaySerie } from '../../../bdtheque/DisplayItem'

  export default {
    name: 'SeriesIndex',
    extends: ModelIndex,
    components: {ModelTree},
    props: {
      routeName: {default: 'serie.card'}
    },
    methods: {
      displayItem: (item) => displaySerie(item)
    }
  }
</script>

<style scoped>

</style>