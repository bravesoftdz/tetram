<template>
	<model-tree
			title="Auteurs"
			model="authors"
			quick-search-fields="nom_personne"
			sort-by="index"
	>
		<template slot="display-item" slot-scope="{ item }">
			{{ displayItem(item) }}
		</template>
	</model-tree>
</template>

<script>
  import ModelIndex from '../ModelIndex'
  import ModelTree from '../../../components/ModelTree'
  import { displayAuthor } from '../../../bdtheque/DisplayItem'

  export default {
    name: 'PersonnesIndex',
    extends: ModelIndex,
    components: {ModelTree},
    props: {
      routeName: {default: 'personne.card'}
    },
    methods: {
      displayItem: (item) => displayAuthor(item)
    }
  }
</script>

<style scoped>

</style>