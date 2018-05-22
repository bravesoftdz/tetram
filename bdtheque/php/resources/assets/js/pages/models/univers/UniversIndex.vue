<template>
	<model-index
			title="Univers"
			model="univers"
			quick-search-fields="nom_univers"
			sort-by="index"
	>
		<template slot="display-item" slot-scope="{ item }">
			{{ displayItem(item) }}
		</template>
	</model-index>
</template>

<script>
  import ModelIndex from '../../../components/ModelIndex'
  import { displayUnivers } from '../../../bdtheque/DisplayItem'

  export default {
    name: 'UniversIndex',
    components: {ModelIndex},
    methods: {
      displayItem: (item) => displayUnivers(item)
    }
  }
</script>

<style scoped>

</style>