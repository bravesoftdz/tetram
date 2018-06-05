<template>
	<model-card title="Album">
		<template slot="media">

		</template>
		<template slot="details">
			<v-layout row justify-start>
				<v-flex id="titre">

				</v-flex>
				<v-flex id="serie">

				</v-flex>
			</v-layout>
		</template>
	</model-card>
</template>

<script>
  import ModelCard from '../../../components/ModelCard'
  import TemplateCard from '../ModelCard'

  export default {
    name: 'AlbumCard',
    extends: TemplateCard,
    components: {ModelCard},
  }
</script>

<style scoped>

</style>