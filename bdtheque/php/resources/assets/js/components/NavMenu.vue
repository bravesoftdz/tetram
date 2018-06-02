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
          {title: 'Tableau de bord', icon: ICONS.TABLEAUDEBORD, route: {name: 'welcome'}},
          {},
          {title: 'Consultation'},
          {title: 'Albums', icon: ICONS.ALBUMS, route: {name: 'albums.index'}},
          {title: 'Séries', icon: ICONS.SERIES, route: {name: 'series.index'}},
          {title: 'Univers', icon: ICONS.UNIVERS, route: {name: 'univers.index'}},
          {title: 'Auteurs', icon: ICONS.AUTEURS, route: {name: 'auteurs.index'}},
          {title: 'ParaBds', icon: ICONS.PARABDS, route: {name: 'parabds.index'}},
        ]
      }
    }
  }
</script>
