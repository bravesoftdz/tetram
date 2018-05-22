<template>
    <div>
        <v-toolbar>
            <v-spacer></v-spacer>
            <!-- <v-toolbar-side-icon class="hidden-md-and-up"></v-toolbar-side-icon> -->
            <v-toolbar-items>
                <v-btn flat v-if="authenticated" :to="{ name: 'home' }">{{ $t('Home') }}</v-btn>
                <template v-else>
                    <v-btn flat :to="{ name: 'login' }">{{ $t('Login') }}</v-btn>
                    <v-btn flat :to="{ name: 'register' }">{{ $t('Register') }}</v-btn>
                </template>
            </v-toolbar-items>
        </v-toolbar>
        <main>
            <v-content>
                <v-container fluid>
                    <v-layout column align-center>
                        <div class="display-3 grey--text m-b-md">
                            {{ title }}
                        </div>
                        <div class="body-2 my-3">
                            <a href="https://laravel.com/docs">{{ $t('Documentation') }}</a>
                            <a href="https://laracasts.com">Laracasts</a>
                            <a href="https://laravel-news.com">{{ $t('News') }}</a>
                            <a href="https://forge.laravel.com">Forge</a>
                            <a href="https://github.com/laravel/laravel">GitHub</a>
                        </div>
                        <img src="/img/v.png" alt="Vuetify.js" class="mt-5">
                        <div class="display-2 grey--text mt-5">
                            Vuetify
                        </div>
                        <div class="body-2 my-3">
                            <a href="https://vuetifyjs.com">{{ $t('Documentation') }}</a>
                            <a href="https://github.com/vuetifyjs/vuetify">GitHub</a>
                        </div>
                    </v-layout>
                </v-container>
            </v-content>
        </main>
    </div>
</template>

<script>
    import {mapGetters} from 'vuex'

    export default {
        name: 'welcome-view',
        layout: 'default',

        metaInfo() {
            return {title: this.$t('Home')}
        },

        computed: mapGetters({
            authenticated: 'authCheck'
        }),

        data: () => ({
            title: window.config.appName
        })
    }
</script>
