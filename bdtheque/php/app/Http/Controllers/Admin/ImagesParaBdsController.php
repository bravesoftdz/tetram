<?php

namespace BDTheque\Http\Controllers\Admin;


use BDTheque\Models\ImageParaBd;

class ImagesParaBdsController extends AdminController
{
    /**
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        return parent::_create();
    }

    /**
     * @param ImagesParaBdsRequest $request
     * @return \Illuminate\Http\RedirectResponse
     * @throws \Illuminate\Auth\Access\AuthorizationException
     */
    public function store(ImagesParaBdsRequest $request)
    {
        return parent::_store($request);
    }

    /**
     * @param ImageParaBd $imageParaBd
     * @return \Illuminate\Http\Response
     */
    public function edit(ImageParaBd $imageParaBd)
    {
        return parent::_edit($imageParaBd);
    }

    /**
     * @param ImagesParaBdsRequest $request
     * @param ImageParaBd $imageParaBd
     * @return \Illuminate\Http\Response
     * @throws \Illuminate\Auth\Access\AuthorizationException
     */
    public function update(ImagesParaBdsRequest $request, ImageParaBd $imageParaBd)
    {
        return parent::_update($request, $imageParaBd);
    }

    /**
     * @param ImageParaBd $imageParaBd
     * @return \Illuminate\Http\Response
     */
    public function delete(ImageParaBd $imageParaBd)
    {
        return parent::_delete($imageParaBd);
    }

    /**
     * @param ImageParaBd $imageParaBd
     * @return \Illuminate\Http\Response
     * @throws \Illuminate\Auth\Access\AuthorizationException
     */
    public function destroy(ImageParaBd $imageParaBd)
    {
        return parent::_destroy($imageParaBd);
    }
}