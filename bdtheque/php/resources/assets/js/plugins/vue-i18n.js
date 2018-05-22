import Vue from 'vue'
import VueI18n from 'vue-i18n'

Vue.use(VueI18n)

const {locale, fallbackLocale} = window.config

export default new VueI18n({
  locale: locale,
  fallbackLocale: fallbackLocale,
  messages: require('./../vue-i18n-locales.generated').default
})
