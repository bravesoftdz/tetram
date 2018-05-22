<template>
	<v-list-tile v-if="to" :to="to">
		<template v-if="icon">
			<v-list-tile-action v-if="use_action">
				<v-icon>{{ icon }}</v-icon>
			</v-list-tile-action>
			<v-icon v-else class="mr-3">{{ icon }}</v-icon>
		</template>
		<v-list-tile-content>
			<v-list-tile-title>{{ title }}</v-list-tile-title>
			<v-list-tile-sub-title v-if="subtitle">{{ subtitle }}</v-list-tile-sub-title>
		</v-list-tile-content>
	</v-list-tile>
	<v-list-tile v-else-if="click" @click.prevent="click">
		<template v-if="icon">
			<v-list-tile-action v-if="use_action">
				<v-icon>{{ icon }}</v-icon>
			</v-list-tile-action>
			<v-icon v-else class="mr-3">{{ icon }}</v-icon>
		</template>
		<v-list-tile-content>
			<v-list-tile-title>{{ title }}</v-list-tile-title>
			<v-list-tile-sub-title v-if="subtitle">{{ subtitle }}</v-list-tile-sub-title>
		</v-list-tile-content>
	</v-list-tile>
</template>
<script>
  export default {
    name: 'menu-item',
    props: {
      title: {type: String, required: true, default: ''},
      subtitle: {type: String, required: false},
      icon: {type: String, required: false},
      to: {type: Object, required: false},
      click: {type: Function, required: false},
      use_action: {type: Boolean, required: false, default: true}
    }
  }
</script>
