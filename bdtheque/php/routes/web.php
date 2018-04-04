<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});

// special cases where model class name must not be singularized to build the paramter name
\Illuminate\Routing\ResourceRegistrar::setParameters(
    \Illuminate\Routing\ResourceRegistrar::getParameters() +
    [
        'univers' => 'univers',
        'imagesalbums' => 'imagealbum',
        'imagesparabds' => 'imageparabd'
    ]
);

// no longer needed when actions method parameter is correctly typed
// Route::model('univers', \BDTheque\Models\Univers::class);
// Route::model('genre', \BDTheque\Models\Genre::class);
// Route::model('personne', \BDTheque\Models\Personne::class);

Route::resource('albums', 'AlbumsController')->only(['index', 'show']);
Route::resource('collections', 'CollectionsController')->only(['index', 'show']);
Route::resource('editeurs', 'EditeursController')->only(['index', 'show']);
Route::resource('editions', 'EditionsController')->only(['index', 'show']);
Route::resource('genres', 'GenresController')->only(['index', 'show']);
Route::resource('imagesalbums', 'ImagesAlbumsController')->only(['index', 'show']);
Route::resource('imagesparabds', 'ImagesParaBdsController')->only(['index', 'show']);
Route::resource('parabds', 'ParaBdsController')->only(['index', 'show']);
Route::resource('personnes', 'PersonnesController')->only(['index', 'show']);
Route::resource('series', 'SeriesController')->only(['index', 'show']);
Route::resource('univers', 'UniversController')->only(['index', 'show']);
Route::resource('users', 'UsersController')->only(['index', 'show']);

Auth::routes();

Route::get('/home', 'HomeController@index')->name('home');
