<?php

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::post('login', 'Auth\LoginController@login');
Route::post('register', 'Auth\RegisterController@register');
Route::post('password/email', 'Auth\ForgotPasswordController@sendResetLinkEmail');
Route::post('password/reset', 'Auth\ResetPasswordController@reset');

Route::pattern('itemId', '[[:xdigit:]]{8}\-[[:xdigit:]]{4}\-[[:xdigit:]]{4}\-[[:xdigit:]]{4}\-[[:xdigit:]]{12}');

Route::post('albums/index', 'AlbumsController@index');
Route::get('albums/{itemId}', 'AlbumsController@get');
Route::post('series/index', 'SeriesController@index');
Route::get('series/{itemId}', 'SeriesController@get');
Route::post('univers/index', 'UniversController@index');
Route::get('univers/{itemId}', 'UniversController@get');
Route::post('authors/index', 'PersonnesController@index');
Route::get('authors/{itemId}', 'PersonnesController@get');
Route::post('parabds/index', 'ParaBdsController@index');
Route::get('parabds/{itemId}', 'ParaBdsController@get');
