import Vue from 'vue'
import Vuetify from 'vuetify'
import store from './store'
import router from './router'
import { i18n, theme } from './plugins/index'
import './mixins/index'
import App from './components/App'
import './components'

Vue.use(Vuetify, {
  theme,
  iconfont: 'mdi'
})

Vue.config.productionTip = false

// eslint-disable-next-line
window.VueInstance = new Vue({
  el: '#app',
  i18n,
  store,
  router,
  ...App
})
