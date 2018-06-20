<template>
	<router-link v-if="routeName" :to="$itemRoute(routeName, item)">
		{{ $formatTitre(item.nom_personne) }}
	</router-link>
	<span v-else>
		{{ $formatTitre(item.nom_personne) }}
	</span>
</template>

<script>

  export default {
    name: 'PersonneDisplay',
    props: {
      item: {type: Object, required: true},
      routeName: {type: String, required: false, default: ''}
    }
  }
</script>

<style scoped>

</style>