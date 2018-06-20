<template>
	<model-tree
			title="Séries"
			model="series"
			quick-search-fields="titre_serie"
			sort-by="index"
	>
		<template slot="display-item" slot-scope="{ item }">
			<router-link :to="$itemRoute(routeName, item)">{{ $displaySerie(item) }}</router-link>
			<model-notation :value="item.notation"/>
		</template>
	</model-tree>
</template>

<script>
  import ModelIndex from '../ModelIndex'
  import ModelTree from '../../../components/ModelTree'
  import ModelNotation from '../../../components/ModelNotation'

  export default {
    name: 'SeriesIndex',
    extends: ModelIndex,
    components: {ModelNotation, ModelTree},
    props: {
      routeName: {default: 'serie.card'}
    },
    methods: {}
  }
</script>

<style scoped>

</style>