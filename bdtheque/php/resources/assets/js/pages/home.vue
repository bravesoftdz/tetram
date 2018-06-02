<template>
	<v-card>
		<v-card-title primary-title class="grey lighten-4">
			<h3 class="headline mb-0">Accueil</h3>
		</v-card-title>
		<v-divider></v-divider>
		<v-card-text>
			Vous êtes connecté(e)
		</v-card-text>
	</v-card>
</template>

<script>
  export default {
    name: 'home-view',
    metaInfo () {
      return {title: 'Accueil'}
    }
  }
</script>
