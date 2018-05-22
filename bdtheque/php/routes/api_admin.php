<?php

use Illuminate\Http\Request;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api_admin" middleware group. Enjoy building your API!
|
*/

Route::post('logout', '\BDTheque\Http\Controllers\Auth\LoginController@logout');

Route::get('/user', function (Request $request) {
    return $request->user();
});

Route::patch('settings/profile', 'SettingsController@updateProfile');
Route::patch('settings/password', 'SettingsController@updatePassword');
