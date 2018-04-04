<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web_admin" middleware group. Now create something great!
|
*/

Route::resource('albums', 'AlbumsController')->except(['index', 'show']);
Route::resource('collections', 'CollectionsController')->except(['index', 'show']);
Route::resource('editeurs', 'EditeursController')->except(['index', 'show']);
Route::resource('editions', 'EditionsController')->except(['index', 'show']);
Route::resource('genres', 'GenresController')->except(['index', 'show']);
Route::resource('imagesalbums', 'ImagesAlbumsController')->except(['index', 'show']);
Route::resource('imagesparabds', 'ImagesParaBdsController')->except(['index', 'show']);
Route::resource('parabds', 'ParaBdsController')->except(['index', 'show']);
Route::resource('personnes', 'PersonnesController')->except(['index', 'show']);
Route::resource('series', 'SeriesController')->except(['index', 'show']);
Route::resource('univers', 'UniversController')->except(['index', 'show']);
Route::resource('users', 'UsersController')->except(['index', 'show']);
