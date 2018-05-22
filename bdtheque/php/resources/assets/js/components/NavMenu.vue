<template>
	<div>
		<v-list dense>
			<tree-popup-menu v-for="(item, index) in items" :key="index" :item="item"></tree-popup-menu>
		</v-list>
	</div>
</template>

<script>
  import { ICONS } from '../consts'
  import TreePopupMenu from './TreePopupMenu'

  export default {
    components: {TreePopupMenu},
    data () {
      return {
        items: [
          {title: 'Dashboard', icon: ICONS.DASHBOARD, route: {name: 'welcome'}},
          {},
          {title: 'Consult'},
          {title: 'Books', icon: ICONS.BOOKS, route: {name: 'books.index'}},
          {title: 'Serials', icon: ICONS.SERIALS, route: {name: 'serials.index'}},
          {title: 'Univers', icon: ICONS.UNIVERS, route: {name: 'univers.index'}},
          {title: 'Authors', icon: ICONS.AUTHORS, route: {name: 'authors.index'}},
          {title: 'Goodies', icon: ICONS.PARABDS, route: {name: 'parabds.index'}},
        ]
      }
    }
  }
</script>
