<template>
	<div>
		<slot v-if="items" name="first"/>
		<template v-for="(item, index) in items">
			<slot v-if="index > 0" name="join">{{ `, ` }}</slot>
			<component :is="modelDisplay" :item="item" :key="index" :route-name="routeName"/>
		</template>
		<slot v-if="items" name="last"/>
	</div>
</template>

<script>
  export default {
    name: 'ModelDisplayList',
    components: {
      PersonneDisplay: require('./personne/PersonneDisplay'),
      UniversDisplay: require('./univers/UniversDisplay'),
      GenreDisplay: require('./genre/GenreDisplay')
    },
    props: {
      items: {type: Function | [Object], required: true, default: () => []},
      routeName: {type: String, required: false, default: ''},
      modelDisplay: {
        default: '',
        validator: value => [
          'PersonneDisplay', 'personne-display',
          'UniversDisplay', 'univers-display',
          'GenreDisplay', 'genre-display'
        ].indexOf(value) !== -1
      }
    }
  }
</script>

<style scoped>

</style>