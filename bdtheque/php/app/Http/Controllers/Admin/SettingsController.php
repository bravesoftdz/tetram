<?php

namespace BDTheque\Http\Controllers\Admin;

use Illuminate\Http\Request;
use BDTheque\Http\Controllers\Controller;

class SettingsController extends Controller
{
    /**
     * Update the user's profile information.
     *
     * @param  \Illuminate\Http\Request $request
     * @return \Illuminate\Http\Response
     */
    public function updateProfile(Request $request)
    {
        $user = $request->user();

        $this->validate($request, [
            'name' => 'required|max:255',
            'email' => 'required|email|unique:users,email,'.$user->id,
        ]);

        return tap($user)->update($request->only('name', 'email'));
    }

    /**
     * Update the user's password.
     *
     * @param  \Illuminate\Http\Request $request
     * @return void
     */
    public function updatePassword(Request $request)
    {
        $this->validate($request, [
            'password' => 'required|confirmed|min:6'
        ]);

        $request->user()->update([
            'password' => bcrypt($request->password)
        ]);
    }

}
