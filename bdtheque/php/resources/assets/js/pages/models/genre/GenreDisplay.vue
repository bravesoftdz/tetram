<template>
	<router-link v-if="routeName" :to="$itemRoute(routeName, item)">
		{{ $formatTitre(item.genre) }}
	</router-link>
	<span v-else>
		{{ $formatTitre(item.genre) }}
	</span>
</template>

<script>

  export default {
    name: 'GenreDisplay',
    props: {
      item: {type: Object, required: true},
      routeName: {type: String, required: false, default: ''}
    }
  }
</script>

<style scoped>

</style>