<?php

namespace BDTheque\Http\Controllers\Admin;

use BDTheque\Models\Album;

class AlbumsController extends AdminController
{
    /**
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        return parent::_create();
    }

    /**
     * @param AlbumsRequest $request
     * @return \Illuminate\Http\RedirectResponse
     * @throws \Illuminate\Auth\Access\AuthorizationException
     */
    public function store(AlbumsRequest $request)
    {
        return parent::_store($request);
    }

    /**
     * @param Album $album
     * @return \Illuminate\Http\Response
     */
    public function edit(Album $album)
    {
        return parent::_edit($album);
    }

    /**
     * @param AlbumsRequest $request
     * @param Album $album
     * @return \Illuminate\Http\Response
     * @throws \Illuminate\Auth\Access\AuthorizationException
     */
    public function update(AlbumsRequest $request, Album $album)
    {
        return parent::_update($request, $album);
    }

    /**
     * @param Album $album
     * @return \Illuminate\Http\Response
     */
    public function delete(Album $album)
    {
        return parent::_delete($album);
    }

    /**
     * @param Album $album
     * @return \Illuminate\Http\Response
     * @throws \Illuminate\Auth\Access\AuthorizationException
     */
    public function destroy(Album $album)
    {
        return parent::_destroy($album);
    }
}