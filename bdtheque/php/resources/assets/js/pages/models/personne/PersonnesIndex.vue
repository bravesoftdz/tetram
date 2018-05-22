<template>
	<model-index
			title="Authors"
			model="authors"
			quick-search-fields="nom_personne"
			sort-by="index"
	>
		<template slot="display-item" slot-scope="{ item }">
			{{ displayItem(item) }}
		</template>
	</model-index>
</template>

<script>
  import ModelIndex from '../../../components/ModelIndex'
  import { displayAuthor } from '../../../bdtheque/DisplayItem'

  export default {
    name: 'PersonnesIndex',
    components: {ModelIndex},
    methods: {
      displayItem: (item) => displayAuthor(item)
	}
  }
</script>

<style scoped>

</style>