<template>
	<v-toolbar
			dark
			app
			dense
			clipped-left
			clipped-right
			color="primary"
	>
		<v-toolbar-side-icon @click.stop="toggleDrawer"></v-toolbar-side-icon>
		<v-toolbar-title>
			<router-link :to="{ name: 'root' }" class="router-link-active white--text">
				{{ appName }}
			</router-link>
		</v-toolbar-title>
		<v-spacer></v-spacer>

		<!-- Authenticated -->
		<template v-if="authenticated">
			<progress-bar :show="busy"></progress-bar>
			<!--<v-btn flat :to="{ name: 'settings.profile' }">{{ user.name }}</v-btn>-->

			<v-menu transition="slide-y-transition" bottom left offset-y lazy>
				<v-btn flat slot="activator">{{ $t('Manage') }}</v-btn>
				<v-list dense>
					<tree-popup-menu v-for="(item, index) in items.manage" :item="item"
									 :key="index"></tree-popup-menu>
				</v-list>
			</v-menu>

			<v-btn icon>
				<v-menu transition="slide-y-transition" bottom left offset-y lazy>
					<v-icon slot="activator" large>account_circle</v-icon>
					<v-list dense>
						<tree-popup-menu v-for="(item, index) in items.account" :item="item"
										 :key="index" :use_action="false"></tree-popup-menu>
						<tree-popup-menu :item="{}"></tree-popup-menu>
						<tree-popup-menu :use_action="false"
										 :item="{title: 'Logout', icon: 'mdi-logout', click:function() { logout() }}">
						</tree-popup-menu>
					</v-list>
				</v-menu>
			</v-btn>
		</template>

		<!-- Guest -->
		<template v-else>
			<v-btn flat :to="{ name: 'login' }">{{ $t('Login') }}</v-btn>
			<!--<v-btn flat :to="{ name: 'register' }">{{ $t('Register') }}</v-btn>-->
		</template>
	</v-toolbar>
</template>

<script>
  import { mapGetters } from 'vuex'
  import TreePopupMenu from './TreePopupMenu'
  import MenuItem from './MenuItem'
  import { ICONS } from '../consts'

  export default {
    components: {MenuItem, TreePopupMenu},
    props: {
      drawer: {
        type: Boolean,
        required: true
      }
    },

    data: () => ({
      appName: window.config.appName,
      busy: false,
      items: {
        account: [
          {title: 'Account', icon: ICONS.ACCOUNT, route: {name: 'settings.profile'}},
        ],
        manage: [
          {title: 'Books', icon: ICONS.BOOKS, route: {name: 'books.list'}},
          {title: 'Serials', icon: ICONS.SERIALS, route: {name: 'serials.list'}},
          {title: 'Authors', icon: ICONS.AUTHORS, route: {name: 'authors.list'}},
          {title: 'Editors', icon: ICONS.EDITORS, route: {name: 'editors.list'}},
          {title: 'Univers', icon: ICONS.UNIVERS, route: {name: 'univers.list'}},
          {title: 'Genders', icon: ICONS.GENDERS, route: {name: 'genders.list'}},
          {title: 'ParaBd', icon: ICONS.PARABDS, route: {name: 'parabds.list'}},
        ]
      }
    }),

    computed: mapGetters({
      user: 'authUser',
      authenticated: 'authCheck'
    }),

    methods: {
      toggleDrawer () {
        this.$emit('toggleDrawer')
      },
      async logout () {
        this.busy = true

        if (this.drawer) {
          this.toggleDrawer()
        }

        // Log out the user.
        await this.$store.dispatch('logout')
        this.busy = false

        // Redirect to root.
        this.$router.push({name: 'root'})
      }
    }
  }
</script>

<style scoped>

	.toolbar__title .router-link-active {
		text-decoration: none;
	}

</style>
