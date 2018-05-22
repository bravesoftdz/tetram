<?php

namespace BDTheque\Http\Controllers\Admin;

use BDTheque\Models\ParaBd;

class ParaBdsController extends AdminController
{
    /**
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        return parent::_create();
    }

    /**
     * @param ParaBdsRequest $request
     * @return \Illuminate\Http\RedirectResponse
     * @throws \Illuminate\Auth\Access\AuthorizationException
     */
    public function store(ParaBdsRequest $request)
    {
        return parent::_store($request);
    }

    /**
     * @param ParaBd $paraBd
     * @return \Illuminate\Http\Response
     */
    public function edit(ParaBd $paraBd)
    {
        return parent::_edit($paraBd);
    }

    /**
     * @param ParaBdsRequest $request
     * @param ParaBd $paraBd
     * @return \Illuminate\Http\Response
     * @throws \Illuminate\Auth\Access\AuthorizationException
     */
    public function update(ParaBdsRequest $request, ParaBd $paraBd)
    {
        return parent::_update($request, $paraBd);
    }

    /**
     * @param ParaBd $paraBd
     * @return \Illuminate\Http\Response
     */
    public function delete(ParaBd $paraBd)
    {
        return parent::_delete($paraBd);
    }

    /**
     * @param ParaBd $paraBd
     * @return \Illuminate\Http\Response
     * @throws \Illuminate\Auth\Access\AuthorizationException
     */
    public function destroy(ParaBd $paraBd)
    {
        return parent::_destroy($paraBd);
    }
}