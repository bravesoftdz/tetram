<?php

namespace BDTheque\Http\Controllers\Admin;


use BDTheque\Models\ImageAlbum;

class ImagesAlbumsController extends AdminController
{
    protected static $modelClass = ImageAlbum::class;

    /**
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        return parent::_create();
    }

    /**
     * @param ImagesAlbumsRequest $request
     * @return \Illuminate\Http\RedirectResponse
     * @throws \Illuminate\Auth\Access\AuthorizationException
     */
    public function store(ImagesAlbumsRequest $request)
    {
        return parent::_store($request);
    }

    /**
     * @param ImageAlbum $imageAlbum
     * @return \Illuminate\Http\Response
     */
    public function edit(ImageAlbum $imageAlbum)
    {
        return parent::_edit($imageAlbum);
    }

    /**
     * @param ImagesAlbumsRequest $request
     * @param ImageAlbum $imageAlbum
     * @return \Illuminate\Http\Response
     * @throws \Illuminate\Auth\Access\AuthorizationException
     */
    public function update(ImagesAlbumsRequest $request, ImageAlbum $imageAlbum)
    {
        return parent::_update($request, $imageAlbum);
    }

    /**
     * @param ImageAlbum $imageAlbum
     * @return \Illuminate\Http\Response
     */
    public function delete(ImageAlbum $imageAlbum)
    {
        return parent::_delete($imageAlbum);
    }

    /**
     * @param ImageAlbum $imageAlbum
     * @return \Illuminate\Http\Response
     * @throws \Illuminate\Auth\Access\AuthorizationException
     */
    public function destroy(ImageAlbum $imageAlbum)
    {
        return parent::_destroy($imageAlbum);
    }
}