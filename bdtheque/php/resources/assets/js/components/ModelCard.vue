<template>
	<v-card>
		<v-card-title class="headline">
			{{ this.title }}
		</v-card-title>
		<v-card-media>
			<slot name="media"/>
		</v-card-media>
		<slot/>
	</v-card>
</template>

<script>
  export default {
    name: 'ModelCard',
    props: {
      title: {
        type: String | Function,
        required: true
      }
    }
  }
</script>

<style scoped>

</style>