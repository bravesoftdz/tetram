<?php

namespace BDTheque\Http\Controllers\Admin;

use BDTheque\Models\Editeur;

class EditeursController extends AdminController
{
    /**
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        return parent::_create();
    }

    /**
     * @param EditeursRequest $request
     * @return \Illuminate\Http\RedirectResponse
     * @throws \Illuminate\Auth\Access\AuthorizationException
     */
    public function store(EditeursRequest $request)
    {
        return parent::_store($request);
    }

    /**
     * @param Editeur $editeur
     * @return \Illuminate\Http\Response
     */
    public function edit(Editeur $editeur)
    {
        return parent::_edit($editeur);
    }

    /**
     * @param EditeursRequest $request
     * @param Editeur $editeur
     * @return \Illuminate\Http\Response
     * @throws \Illuminate\Auth\Access\AuthorizationException
     */
    public function update(EditeursRequest $request, Editeur $editeur)
    {
        return parent::_update($request, $editeur);
    }

    /**
     * @param Editeur $editeur
     * @return \Illuminate\Http\Response
     */
    public function delete(Editeur $editeur)
    {
        return parent::_delete($editeur);
    }

    /**
     * @param Editeur $editeur
     * @return \Illuminate\Http\Response
     * @throws \Illuminate\Auth\Access\AuthorizationException
     */
    public function destroy(Editeur $editeur)
    {
        return parent::_destroy($editeur);
    }
}