@extends('layouts.common')

@section('header')
    <!-- CSRF Token -->
    <meta name="csrf-token" content="{{ csrf_token() }}">

    <!-- Fonts -->
    <link rel="dns-prefetch" href="https://fonts.gstatic.com">

    <!-- Styles -->
    <link href="{{ asset('css/app.css') }}" rel="stylesheet">

    <!-- Scripts -->
    <script>
        const Laravel = {
            locale: "{{ config('app.locale') }}",
            fallbackLocale: "{{ config('app.fallback_locale') }}"
        };
    </script>
    <script src="{{ asset('js/manifest.js') }}" defer></script>
    <script src="{{ asset('js/vendor.js') }}" defer></script>
    <script src="{{ asset('js/app.js') }}" defer></script>
@endsection

@section('body')
    <div id="app">
        <v-app dark>
            <v-navigation-drawer
                    app
                    fixed
                    clipped
                    v-model="drawer"
            >
                @yield('drawer')
            </v-navigation-drawer>
            <v-toolbar
                    app
                    dense
                    clipped-left
                    clipped-right
            >
                <v-toolbar-side-icon @click.native="drawer = !drawer"></v-toolbar-side-icon>
                <v-toolbar-title>{{ config('app.name') }}</v-toolbar-title>
                <v-spacer></v-spacer>
                @yield('toolbar')
                <v-btn icon>
                    <v-menu transition="slide-y-transition" bottom left offset-y>
                        <v-icon slot="activator" large color="primary">account_circle</v-icon>
                        <v-list>
                            @guest
                                <v-list-tile>
                                    <v-btn align-left small flat block href="{{ route('login') }}">{{ __('Login') }}</v-btn>
                                </v-list-tile>
                                <v-list-tile>
                                    <v-btn align-left small flat block href="{{ route('register') }}">{{ __('Register') }}</v-btn>
                                </v-list-tile>
                            @else
                                <li class="nav-item dropdown">
                                    <a id="navbarDropdown" class="nav-link dropdown-toggle" href="#" role="button"
                                       data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" v-pre>
                                        {{ Auth::user()->name }} <span class="caret"></span>
                                    </a>

                                    <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                                        <a class="dropdown-item" href="{{ route('logout') }}"
                                           onclick="event.preventDefault();
                                                 document.getElementById('logout-form').submit();">
                                            {{ __('Logout') }}
                                        </a>

                                        <form id="logout-form" action="{{ route('logout') }}" method="POST"
                                              style="display: none;">
                                            @csrf
                                        </form>
                                    </div>
                                </li>
                            @endguest
                        </v-list>
                    </v-menu>
                </v-btn>
            </v-toolbar>


            <v-content>
                @yield('content')
            </v-content>
            <v-footer
                    app
            >
                &copy; {{ date("Y") }}
            </v-footer>
        </v-app>
    </div>
@endsection

<script type="application/javascript" defer>
    export default {
        data: () => ({
            drawer: null
        })
    }
</script>
