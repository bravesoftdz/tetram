{{-- Global configuration object --}}
@php
    $config = [
        'appName' => config('app.name'),
        'locale' => $locale = config('app.locale'),
        'fallbackLocale' => $fallbackLocale = config('app.fallback_locale'),
    ];
@endphp
<script>window.config = {!! json_encode($config); !!};</script>

{{-- Load the application scripts --}}
<script src="{{ asset('js/manifest.js') }}"></script>
<script src="{{ asset('js/vendor.js') }}"></script>
<script src="{{ asset('js/app.js') }}"></script>
