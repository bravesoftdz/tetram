<template>
	<router-link v-if="routeName" :to="$itemRoute(routeName, item)">
		{{ $formatTitre(item.nom_univers) }}
	</router-link>
	<span v-else>
		{{ $formatTitre(item.nom_univers) }}
	</span>
</template>

<script>

  export default {
    name: 'UniversDisplay',
    props: {
      item: {type: Object, required: true},
      routeName: {type: String, required: false, default: ''}
    }
  }
</script>

<style scoped>

</style>