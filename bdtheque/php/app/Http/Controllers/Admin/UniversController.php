<?php

namespace BDTheque\Http\Controllers\Admin;

use BDTheque\Http\Requests\UniversRequest;
use BDTheque\Models\Univers;

class UniversController extends AdminController
{
    /**
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        return parent::_create();
    }

    /**
     * @param UniversRequest $request
     * @return \Illuminate\Http\RedirectResponse
     * @throws \Illuminate\Auth\Access\AuthorizationException
     */
    public function store(UniversRequest $request)
    {
        return parent::_store($request);
    }

    /**
     * @param Univers $univers
     * @return \Illuminate\Http\Response
     */
    public function edit(Univers $univers)
    {
        return parent::_edit($univers);
    }

    /**
     * @param UniversRequest $request
     * @param Univers $univers
     * @return \Illuminate\Http\Response
     * @throws \Illuminate\Auth\Access\AuthorizationException
     */
    public function update(UniversRequest $request, Univers $univers)
    {
        return parent::_update($request, $univers);
    }

    /**
     * @param Univers $univers
     * @return \Illuminate\Http\Response
     */
    public function delete(Univers $univers)
    {
        return parent::_delete($univers);
    }

    /**
     * @param Univers $univers
     * @return \Illuminate\Http\Response
     * @throws \Illuminate\Auth\Access\AuthorizationException
     */
    public function destroy(Univers $univers)
    {
        return parent::_destroy($univers);
    }
}