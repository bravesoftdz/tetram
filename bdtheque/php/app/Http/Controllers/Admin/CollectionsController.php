<?php

namespace BDTheque\Http\Controllers\Admin;

use BDTheque\Models\Collection;

class CollectionsController extends AdminController
{
    /**
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        return parent::_create();
    }

    /**
     * @param CollectionsRequest $request
     * @return \Illuminate\Http\RedirectResponse
     * @throws \Illuminate\Auth\Access\AuthorizationException
     */
    public function store(CollectionsRequest $request)
    {
        return parent::_store($request);
    }

    /**
     * @param Collection $collection
     * @return \Illuminate\Http\Response
     */
    public function edit(Collection $collection)
    {
        return parent::_edit($collection);
    }

    /**
     * @param CollectionsRequest $request
     * @param Collection $collection
     * @return \Illuminate\Http\Response
     * @throws \Illuminate\Auth\Access\AuthorizationException
     */
    public function update(CollectionsRequest $request, Collection $collection)
    {
        return parent::_update($request, $collection);
    }

    /**
     * @param Collection $collection
     * @return \Illuminate\Http\Response
     */
    public function delete(Collection $collection)
    {
        return parent::_delete($collection);
    }

    /**
     * @param Collection $collection
     * @return \Illuminate\Http\Response
     * @throws \Illuminate\Auth\Access\AuthorizationException
     */
    public function destroy(Collection $collection)
    {
        return parent::_destroy($collection);
    }
}