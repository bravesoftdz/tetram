export default ({authGuard, guestGuard}) => [
  // {path: '/', name: 'welcome', component: require('../pages/welcome.vue')},
  {path: '/', redirect: {name: 'welcome'}, name: 'root'},
  {path: '/welcome', name: 'welcome', component: require('../pages/home.vue')},

  // Authenticated routes.
  ...authGuard([
    {path: '/home', name: 'home', component: require('../pages/home.vue')},
    {
      path: '/settings',
      component: require('../pages/settings/index.vue'),
      children: [
        {path: '', redirect: {name: 'settings.profile'}}, // important: not to use nested views router behavior
        {path: 'profile', name: 'settings.profile', component: require('../pages/settings/profile.vue')},
        {path: 'password', name: 'settings.password', component: require('../pages/settings/password.vue')}
      ]
    }
  ]),

  // Guest routes.
  ...guestGuard([
    {path: '/login', name: 'login', component: require('../pages/auth/login.vue')},
    // {path: '/register', name: 'register', component: require('../pages/auth/register.vue')},
    {path: '/password/reset', name: 'password.request', component: require('../pages/auth/password/email.vue')},
    {path: '/password/reset/:token', name: 'password.reset', component: require('../pages/auth/password/reset.vue')},
    {path: '/albums', name: 'albums.index', component: require('../pages/models/album/AlbumsIndex.vue')},
    {path: '/series', name: 'series.index', component: require('../pages/models/serie/SeriesIndex.vue')},
    {path: '/auteurs', name: 'auteurs.index', component: require('../pages/models/personne/PersonnesIndex')},
    {path: '/univers', name: 'univers.index', component: require('../pages/models/univers/UniversIndex')},
    {path: '/parabds', name: 'parabds.index', component: require('../pages/models/parabd/ParabdsIndex')},
    {
      path: '/admin',
      children:
        [
          {path: 'albums', name: 'albums.list'},
          {path: 'series', name: 'series.list'},
          {path: 'auteurs', name: 'auteurs.list'},
          {path: 'editeurs', name: 'editeurs.list'},
          {path: 'univers', name: 'univers.list'},
          {path: 'genres', name: 'genres.list'},
          {path: 'parabds', name: 'parabds.list'}]
    }
  ]),

  {path: '*', component: require('../pages/errors/404.vue')}
]
