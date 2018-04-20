<?php

namespace BDTheque\Http\Controllers\Admin;

use BDTheque\Models\Genre;

class GenresController extends AdminController
{
    /**
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        return parent::_create();
    }

    /**
     * @param GenresRequest $request
     * @return \Illuminate\Http\RedirectResponse
     * @throws \Illuminate\Auth\Access\AuthorizationException
     */
    public function store(GenresRequest $request)
    {
        return parent::_store($request);
    }

    /**
     * @param Genre $genre
     * @return \Illuminate\Http\Response
     */
    public function edit(Genre $genre)
    {
        return parent::_edit($genre);
    }

    /**
     * @param GenresRequest $request
     * @param Genre $genre
     * @return \Illuminate\Http\Response
     * @throws \Illuminate\Auth\Access\AuthorizationException
     */
    public function update(GenresRequest $request, Genre $genre)
    {
        return parent::_update($request, $genre);
    }

    /**
     * @param Genre $genre
     * @return \Illuminate\Http\Response
     */
    public function delete(Genre $genre)
    {
        return parent::_delete($genre);
    }

    /**
     * @param Genre $genre
     * @return \Illuminate\Http\Response
     * @throws \Illuminate\Auth\Access\AuthorizationException
     */
    public function destroy(Genre $genre)
    {
        return parent::_destroy($genre);
    }
}