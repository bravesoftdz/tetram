<template>
	<model-index
			title="Séries"
			model="series"
			quick-search-fields="titre_serie"
			sort-by="index"
	>
		<template slot="display-item" slot-scope="{ item }">
			{{ displayItem(item) }}
		</template>
	</model-index>
</template>

<script>
  import ModelIndex from '../../../components/ModelIndex'
  import { displaySerie } from '../../../bdtheque/DisplayItem'

  export default {
    name: 'SeriesIndex',
    components: {ModelIndex},
    methods: {
      displayItem: (item) => displaySerie(item)
	}
  }
</script>

<style scoped>

</style>