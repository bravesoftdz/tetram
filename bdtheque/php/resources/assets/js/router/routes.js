export default ({authGuard, guestGuard}) => [
  // {path: '/', name: 'welcome', component: require('../pages/welcome')},
  {path: '/', redirect: {name: 'welcome'}, name: 'root'},
  {path: '/welcome', name: 'welcome', component: require('../pages/home')},

  {path: '/albums', name: 'albums.index', component: require('../pages/models/album/AlbumsIndex')},
  {path: '/albums/:itemId', name: 'album.card', component: require('../pages/models/album/AlbumCard'), props: true},
  {path: '/series', name: 'series.index', component: require('../pages/models/serie/SeriesIndex')},
  {path: '/series/:itemId', name: 'serie.card', component: require('../pages/models/serie/SerieCard'), props: true},
  {path: '/auteurs', name: 'auteurs.index', component: require('../pages/models/personne/PersonnesIndex')},
  {path: '/auteurs/:itemId', name: 'auteur.card', component: require('../pages/models/personne/PersonneCard'), props: true},
  {path: '/univers', name: 'univers.index', component: require('../pages/models/univers/UniversIndex')},
  {path: '/univers/:itemId', name: 'univers.card', component: require('../pages/models/univers/UniversCard'), props: true},
  {path: '/parabds', name: 'parabds.index', component: require('../pages/models/parabd/ParabdsIndex')},
  {path: '/parabds/:itemId', name: 'parabd.card', component: require('../pages/models/parabd/ParabdCard'), props: true},

  // Authenticated routes.
  ...authGuard([
    {path: '/home', name: 'home', component: require('../pages/home')},
    {
      path: '/settings',
      component: require('../pages/settings/index'),
      children: [
        {path: '', redirect: {name: 'settings.profile'}}, // important: not to use nested views router behavior
        {path: 'profile', name: 'settings.profile', component: require('../pages/settings/profile')},
        {path: 'password', name: 'settings.password', component: require('../pages/settings/password')}
      ]
    },
    {path: '/admin/albums', name: 'albums.list', component: require('../pages/models/album/AlbumsList')},
    {path: '/admin/albums/:itemId', name: 'album.form', component: require('../pages/models/album/AlbumForm'), props: true},
    {path: '/admin/series', name: 'series.list', component: require('../pages/models/serie/SeriesList')},
    {path: '/admin/series/:itemId', name: 'serie.form', component: require('../pages/models/serie/SerieForm'), props: true},
    {path: '/admin/auteurs', name: 'auteurs.list', component: require('../pages/models/personne/PersonnesList')},
    {path: '/admin/auteurs/:itemId', name: 'auteur.form', component: require('../pages/models/personne/PersonneForm'), props: true},
    {path: '/admin/univers', name: 'univers.list', component: require('../pages/models/univers/UniversList')},
    {path: '/admin/univers/:itemId', name: 'univers.form', component: require('../pages/models/univers/UniversForm'), props: true},
    {path: '/admin/parabds', name: 'parabds.list', component: require('../pages/models/parabd/ParabdsList')},
    {path: '/admin/parabds/:itemId', name: 'parabd.form', component: require('../pages/models/parabd/ParabdForm'), props: true}
  ]),

  // Guest routes.
  ...guestGuard([
    {path: '/login', name: 'login', component: require('../pages/auth/login')},
    // {path: '/register', name: 'register', component: require('../pages/auth/register')},
    {path: '/password/reset', name: 'password.request', component: require('../pages/auth/password/email')},
    {path: '/password/reset/:token', name: 'password.reset', component: require('../pages/auth/password/reset')}
  ]),

  {path: '*', component: require('../pages/errors/404')}
]
