<?php

namespace BDTheque\Policies;

use BDTheque\Models\BaseModel;
use BDTheque\Models\User;
use Illuminate\Auth\Access\HandlesAuthorization;

class ModelPolicy
{
    use HandlesAuthorization;

    /**
     * Create a new policy instance.
     *
     * @return void
     */
    public function __construct()
    {
        //
    }

    /**
     * Grant all abilities to administrator.
     *
     * @param User $user
     * @return bool
     */
    public function before(User $user)
    {
//        if ($user->role === 'admin') {
//            return true;
//        }
    }

    /**
     * Is $user allowed to create the new $model ?
     *
     * @param User $user
     * @param BaseModel $model
     * @return bool
     */
    public function create(User $user, BaseModel $model)
    {
        return true;
    }

    /**
     * Is $user allowed to update $model ?
     *
     * @param User $user
     * @param BaseModel $model
     * @return bool
     */
    public function update(User $user, BaseModel $model)
    {
        return true;
    }

    /**
     * Is $user allowed to delete $model ?
     *
     * @param User $user
     * @param BaseModel $model
     * @return bool
     */
    public function delete(User $user, BaseModel $model)
    {
        return true;
    }
}
