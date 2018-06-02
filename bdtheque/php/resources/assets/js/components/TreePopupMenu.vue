<template>
	<v-menu v-if="item.items" offset-x open-on-hover>
		<v-list-tile slot="activator" @click="">
			<menu-item :title="item.title" :icon="item.icon">
				<v-list-tile-action class="justify-end">
					<v-icon>play_arrow</v-icon>
				</v-list-tile-action>
			</menu-item>
		</v-list-tile>
		<v-list dense>
			<tree-popup-menu
					v-for="(subitem, index) in item.items"
					:item="subitem"
					:key="index"
					class="pl-3"
					:use_action="use_action"
			>
			</tree-popup-menu>
		</v-list>
	</v-menu>
	<menu-item
			v-else-if="item.route || item.click"
			:title="item.title" :icon="item.icon"
			:to="item.route" :click="item.click"
			:use_action="use_action">
	</menu-item>
	<v-divider v-else-if="!item.title"></v-divider>
	<v-subheader v-else>
		<v-icon v-if="item.icon" class="mr-3">{{ item.icon }}</v-icon>
		{{ item.title }}
	</v-subheader>
</template>

<script>
  import MenuItem from './MenuItem'

  export default {
    name: 'TreePopupMenu',
    components: {MenuItem},
    props: {
      item: {type: Object, required: true, default: function () {return {}}},
      use_action: {type: Boolean, required: false, default: true}
    }
  }
</script>

<style scoped>

</style>