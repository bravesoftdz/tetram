<template>
	<model-index
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