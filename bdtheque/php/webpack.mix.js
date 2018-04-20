let mix = require('laravel-mix');

/*
 |--------------------------------------------------------------------------
 | Mix Asset Management
 |--------------------------------------------------------------------------
 |
 | Mix provides a clean, fluent API for defining some Webpack build steps
 | for your Laravel application. By default, we are compiling the Sass
 | file for the application as well as bundling up all the JS files.
 |
 */

// package_cfg = ["axios","bootstrap","decamelize","jquery","lodash","path-parse","popper.js","vue","vue-i18n"];
package_cfg = [];

let package_file = require('./package.json');
for (package in package_file.dependencies) {
    package_cfg.push(package);
}

mix.js('resources/assets/js/app.js', 'public/js')
    .sass('resources/assets/sass/app.scss', 'public/css')
    .extract(package_cfg)
;
