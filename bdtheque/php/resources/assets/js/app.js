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

// manually registering a component helps phpStorm providing useful coding support
Vue.component('icon-base', require('./components/IconBase'));
Vue.component('icon-heart-face', require('./components/Animatedicons/IconHeartFace'));
Vue.component('icon-palette', require('./components/Animatedicons/IconPalette'));
Vue.component('icon-scissors', require('./components/Animatedicons/IconScissors'));
Vue.component('icon-watch', require('./components/Animatedicons/IconWatch'));
Vue.component('icon-box', require('./components/Icons/IconBox'));
Vue.component('icon-calendar', require('./components/Icons/IconCalendar'));
Vue.component('icon-envelope', require('./components/Icons/IconEnvelope'));
Vue.component('icon-garbage', require('./components/Icons/IconGarbage'));
Vue.component('icon-image', require('./components/Icons/IconImage'));
Vue.component('icon-moon', require('./components/Icons/IconMoon'));
Vue.component('icon-write', require('./components/Icons/IconWrite'));

Vue.component('input-checkbox', require('./components/Inputs/InputCheckbox'));
Vue.component('input-radio', require('./components/Inputs/InputRadio'));
Vue.component('input-text', require('./components/Inputs/InputText'));

Vue.component('album-card', require('./components/Models/Albums/AlbumCard'));
Vue.component('album-form', require('./components/Models/Albums/AlbumForm'));
Vue.component('album-list-item', require('./components/Models/Albums/AlbumListItem'));
Vue.component('collection-card', require('./components/Models/Collections/CollectionCard'));
Vue.component('collection-form', require('./components/Models/Collections/CollectionForm'));
Vue.component('collection-list-item', require('./components/Models/Collections/CollectionListItem'));
Vue.component('editeur-card', require('./components/Models/Editeurs/EditeurCard'));
Vue.component('editeur-form', require('./components/Models/Editeurs/EditeurForm'));
Vue.component('editeur-list-item', require('./components/Models/Editeurs/EditeurListItem'));
Vue.component('edition-card', require('./components/Models/Editions/EditionCard'));
Vue.component('edition-form', require('./components/Models/Editions/EditionForm'));
Vue.component('edition-list-item', require('./components/Models/Editions/EditionListItem'));
Vue.component('genre-card', require('./components/Models/Genres/GenreCard'));
Vue.component('genre-form', require('./components/Models/Genres/GenreForm'));
Vue.component('genre-list-item', require('./components/Models/Genres/GenreListItem'));
Vue.component('parabd-card', require('./components/Models/ParaBds/ParabdCard'));
Vue.component('parabd-form', require('./components/Models/ParaBds/ParabdForm'));
Vue.component('parabd-list-item', require('./components/Models/ParaBds/ParabdListItem'));
Vue.component('personne-card', require('./components/Models/Personnes/PersonneCard'));
Vue.component('personne-form', require('./components/Models/Personnes/PersonneForm'));
Vue.component('personne-list-item', require('./components/Models/Personnes/PersonneListItem'));
Vue.component('serie-card', require('./components/Models/Series/SerieCard'));
Vue.component('serie-form', require('./components/Models/Series/SerieForm'));
Vue.component('serie-list-item', require('./components/Models/Series/SerieListItem'));
Vue.component('univers-card', require('./components/Models/Univers/UniversCard'));
Vue.component('univers-form', require('./components/Models/Univers/UniversForm'));
Vue.component('univers-list-item', require('./components/Models/Univers/UniversListItem'));

// auto registration allows not to register all needed components

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
