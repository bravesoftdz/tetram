<?php

namespace BDTheque\Http\Controllers\Admin;

use BDTheque\Models\Edition;

class EditionsController extends AdminController
{
    /**
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        return parent::_create();
    }

    /**
     * @param EditionsRequest $request
     * @return \Illuminate\Http\RedirectResponse
     * @throws \Illuminate\Auth\Access\AuthorizationException
     */
    public function store(EditionsRequest $request)
    {
        return parent::_store($request);
    }

    /**
     * @param Edition $edition
     * @return \Illuminate\Http\Response
     */
    public function edit(Edition $edition)
    {
        return parent::_edit($edition);
    }

    /**
     * @param EditionsRequest $request
     * @param Edition $edition
     * @return \Illuminate\Http\Response
     * @throws \Illuminate\Auth\Access\AuthorizationException
     */
    public function update(EditionsRequest $request, Edition $edition)
    {
        return parent::_update($request, $edition);
    }

    /**
     * @param Edition $edition
     * @return \Illuminate\Http\Response
     */
    public function delete(Edition $edition)
    {
        return parent::_delete($edition);
    }

    /**
     * @param Edition $edition
     * @return \Illuminate\Http\Response
     * @throws \Illuminate\Auth\Access\AuthorizationException
     */
    public function destroy(Edition $edition)
    {
        return parent::_destroy($edition);
    }
}