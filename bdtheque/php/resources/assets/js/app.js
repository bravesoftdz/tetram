/**
 * First we will load all of this project's JavaScript dependencies which
 * includes Vue and other libraries. It is a great starting point when
 * building robust, powerful web applications using Vue and Laravel.
 */


require('./bootstrap');

window.Vue = require('vue');

import VueI18n from "vue-i18n";
Vue.use(VueI18n);
const i18n = new VueI18n({
    locale: Laravel.locale,
    fallbackLocale: Laravel.fallbackLocale,
    messages: require('./vue-i18n-locales.generated')
});

/**
 * Next, we will create a fresh Vue application instance and attach it to
 * the page. Then, you may begin adding components to this application
 * or customize the JavaScript scaffolding to fit your unique needs.
 */

import decamelize from 'decamelize';
import pathParse from 'path-parse';

const requireComponent = require.context('./components', true, /\.(vue|js)$/);
requireComponent.keys().forEach(fileName => {
    const componentConfig = requireComponent(fileName);
    const componentName = decamelize(pathParse(fileName).name, '-');
    Vue.component(componentName, componentConfig.default || componentConfig);
});

const app = new Vue({
    el: '#app',
    i18n,
    components: {

    }
});
