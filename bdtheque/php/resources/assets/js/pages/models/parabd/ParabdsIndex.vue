<template>
	<model-index
			title="Goodies"
			model="parabds"
			quick-search-fields="titre_parabd"
			sort-by="index"
	>
		<template slot="display-item" slot-scope="{ item }">
			{{ displayItem(item) }}
		</template>
	</model-index>
</template>

<script>
  import ModelIndex from '../../../components/ModelIndex'
  import { displayParaBd } from '../../../bdtheque/DisplayItem'

  export default {
    name: 'ParabdsIndex',
    components: {ModelIndex},
    methods: {
      displayItem: (item) => displayParaBd(item)
	}
  }
</script>

<style scoped>

</style>