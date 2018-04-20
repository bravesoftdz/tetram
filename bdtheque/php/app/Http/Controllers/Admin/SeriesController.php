<?php

namespace BDTheque\Http\Controllers\Admin;

use BDTheque\Models\Serie;

class SeriesController extends AdminController
{
    /**
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        return parent::_create();
    }

    /**
     * @param SeriesRequest $request
     * @return \Illuminate\Http\RedirectResponse
     * @throws \Illuminate\Auth\Access\AuthorizationException
     */
    public function store(SeriesRequest $request)
    {
        return parent::_store($request);
    }

    /**
     * @param Serie $serie
     * @return \Illuminate\Http\Response
     */
    public function edit(Serie $serie)
    {
        return parent::_edit($serie);
    }

    /**
     * @param SeriesRequest $request
     * @param Serie $serie
     * @return \Illuminate\Http\Response
     * @throws \Illuminate\Auth\Access\AuthorizationException
     */
    public function update(SeriesRequest $request, Serie $serie)
    {
        return parent::_update($request, $serie);
    }

    /**
     * @param Serie $serie
     * @return \Illuminate\Http\Response
     */
    public function delete(Serie $serie)
    {
        return parent::_delete($serie);
    }

    /**
     * @param Serie $serie
     * @return \Illuminate\Http\Response
     * @throws \Illuminate\Auth\Access\AuthorizationException
     */
    public function destroy(Serie $serie)
    {
        return parent::_destroy($serie);
    }
}