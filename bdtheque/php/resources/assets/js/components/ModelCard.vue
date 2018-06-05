<template>
	<v-card>
		<v-card-title>{{ this.title }}</v-card-title>
		<v-card-media>
			<slot name="media"></slot>
		</v-card-media>
		<slot name="details"></slot>
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