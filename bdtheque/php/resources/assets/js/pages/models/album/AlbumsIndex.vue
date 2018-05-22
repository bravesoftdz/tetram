<template>
	<model-index
			title="Books"
			model="albums"
			:quick-search-fields="['titre_album', 'serie.titre_serie']"
			sort-by="index"
			group-by="serie"
			group-by-sort="index"
	>
		<template slot="display-item" slot-scope="{ item }">
			{{ displayItem(item) }}
		</template>
	</model-index>
</template>

<script>
  import ModelIndex from '../../../components/ModelIndex'
  import { displayAlbum } from '../../../bdtheque/DisplayItem'

  export default {
    name: 'AlbumsIndex',
    components: {ModelIndex},
    methods: {
      displayItem: (item) => displayAlbum(item)
    }
  }
</script>

<style scoped>

</style>