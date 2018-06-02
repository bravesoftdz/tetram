<template>
	<main>
		<v-content>
			<v-container fluid>
				<v-layout column align-center>
					<div class="display-3 grey--text mt-5">Page non trouvée</div>
					<div class="body-2 my-3">
						<router-link :to="{ name: 'welcome' }">Retour à l'accueil</router-link>
					</div>
				</v-layout>
			</v-container>
		</v-content>
	</main>
</template>

<script>
  export default {
    name: 'not-found',
    layout: 'default'
  }
</script>
