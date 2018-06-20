<template>
	<model-tree
			title="Auteurs"
			model="authors"
			quick-search-fields="nom_personne"
			sort-by="index"
	>
		<template slot="display-item" slot-scope="{ item }">
			<router-link :to="$itemRoute(routeName, item)">{{ $displayAuthor(item) }}</router-link>
		</template>
	</model-tree>
</template>

<script>
  import ModelIndex from '../ModelIndex'
  import ModelTree from '../../../components/ModelTree'

  export default {
    name: 'PersonnesIndex',
    extends: ModelIndex,
    components: {ModelTree},
    props: {
      routeName: {default: 'auteur.card'}
    },
    methods: {
    }
  }
</script>

<style scoped>

</style>