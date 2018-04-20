<?php

namespace BDTheque\Http\Controllers\Admin;

use BDTheque\Models\User;

class UsersController extends AdminController
{
    /**
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        return parent::_create();
    }

    /**
     * @param UsersRequest $request
     * @return \Illuminate\Http\RedirectResponse
     * @throws \Illuminate\Auth\Access\AuthorizationException
     */
    public function store(UsersRequest $request)
    {
        return parent::_store($request);
    }

    /**
     * @param User $user
     * @return \Illuminate\Http\Response
     */
    public function edit(User $user)
    {
        return parent::_edit($user);
    }

    /**
     * @param UsersRequest $request
     * @param User $user
     * @return \Illuminate\Http\Response
     * @throws \Illuminate\Auth\Access\AuthorizationException
     */
    public function update(UsersRequest $request, User $user)
    {
        return parent::_update($request, $user);
    }

    /**
     * @param User $user
     * @return \Illuminate\Http\Response
     */
    public function delete(User $user)
    {
        return parent::_delete($user);
    }

    /**
     * @param User $user
     * @return \Illuminate\Http\Response
     * @throws \Illuminate\Auth\Access\AuthorizationException
     */
    public function destroy(User $user)
    {
        return parent::_destroy($user);
    }
}