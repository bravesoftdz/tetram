<?php

namespace BDTheque\Http\Controllers\Admin;

use BDTheque\Models\Personne;

class PersonnesController extends AdminController
{
    /**
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        return parent::_create();
    }

    /**
     * @param PersonnesRequest $request
     * @return \Illuminate\Http\RedirectResponse
     * @throws \Illuminate\Auth\Access\AuthorizationException
     */
    public function store(PersonnesRequest $request)
    {
        return parent::_store($request);
    }

    /**
     * @param Personne $personne
     * @return \Illuminate\Http\Response
     */
    public function edit(Personne $personne)
    {
        return parent::_edit($personne);
    }

    /**
     * @param PersonnesRequest $request
     * @param Personne $personne
     * @return \Illuminate\Http\Response
     * @throws \Illuminate\Auth\Access\AuthorizationException
     */
    public function update(PersonnesRequest $request, Personne $personne)
    {
        return parent::_update($request, $personne);
    }

    /**
     * @param Personne $personne
     * @return \Illuminate\Http\Response
     */
    public function delete(Personne $personne)
    {
        return parent::_delete($personne);
    }

    /**
     * @param Personne $personne
     * @return \Illuminate\Http\Response
     * @throws \Illuminate\Auth\Access\AuthorizationException
     */
    public function destroy(Personne $personne)
    {
        return parent::_destroy($personne);
    }
}
