let mix = require('laravel-mix')

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

// packagesList = ["axios","bootstrap","decamelize","jquery","lodash","path-parse","popper.js","vue","vue-i18n"];
let packagesList = []

let packageFiles = require('./package.json')
for (let packageFile in packageFiles.dependencies) {
  packagesList.push(packageFile)
}

mix.js('resources/assets/js/app.js', 'public/js')
  .sass('resources/assets/sass/app.scss', 'public/css')
  .extract(packagesList)
  .sourceMaps()
