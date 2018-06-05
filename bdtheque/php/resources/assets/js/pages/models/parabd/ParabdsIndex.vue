<template>
	<model-tree
			title="ParaBds"
			model="parabds"
			quick-search-fields="titre_parabd"
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
  import { displayParaBd } from '../../../bdtheque/DisplayItem'

  export default {
    name: 'ParabdsIndex',
    extends: ModelIndex,
    components: {ModelTree},
    props: {
      routeName: {default: 'parabd.card'}
    },
    methods: {
      displayItem: (item) => displayParaBd(item)
    }
  }
</script>

<style scoped>

</style>