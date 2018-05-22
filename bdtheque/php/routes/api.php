<?php

use Illuminate\Http\Request;

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

Route::post('albums/index', 'AlbumsController@index');
Route::post('series/index', 'SeriesController@index');
Route::post('univers/index', 'UniversController@index');
Route::post('authors/index', 'PersonnesController@index');
Route::post('parabds/index', 'ParaBdsController@index');