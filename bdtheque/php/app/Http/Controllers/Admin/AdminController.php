<?php

namespace BDTheque\Http\Controllers\Admin;


use BDTheque\Http\Controllers\Controller;
use BDTheque\Http\Controllers\TraitModelController;
use BDTheque\Models\BaseModel;
use Illuminate\Http\Request;
use Ramsey\Uuid\Uuid;

abstract class AdminController extends Controller
{
    use TraitModelController;

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        return view()->first([self::getModelView('create'), self::getModelView('edit')])->with(self::getModelViewTag(), null);
    }

    /**
     * Edit the specified resource.
     *
     * @param Uuid $id
     * @return \Illuminate\Http\Response
     */
    public function edit(string $id)
    {
        return view(self::getModelView('edit'))->with(self::getModelViewTag(), self::getModel($id));
    }

    /**
     * Display the specified resource.
     *
     * @param Uuid $id
     * @return \Illuminate\Http\Response
     */
    public function delete(Uuid $id)
    {
        return view(self::getModelView('delete'))->with(self::getModelViewTag(), self::getModel($id));
    }

    /**
     * Create a new resource in storage
     *
     * @param Request $request
     * @return \Illuminate\Http\RedirectResponse
     * @throws \Illuminate\Auth\Access\AuthorizationException
     */
    public function store(Request $request)
    {
        /** @var BaseModel $model */
        $modelClass = self::getModelClass();
        $model = new $modelClass($request);
        $this->authorize('store', $model);

        $model->save();

        return redirect()->route(self::getModelView('index'))->with('success', "The brand <strong>{self::modelClassName()}</strong> has successfully been created.");
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request $request
     * @param Uuid $id
     * @return \Illuminate\Http\Response
     * @throws \Illuminate\Auth\Access\AuthorizationException
     */
    public function update(Request $request, Uuid $id)
    {
        $model = self::getModel($id);
        $this->authorize('update', $model);

        $model->save();

        return redirect()->route(self::getModelView('index'))->with('success', "The brand <strong>{self::modelClassName()}</strong> has successfully been updated.");
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param Uuid $id
     * @return \Illuminate\Http\Response
     * @throws \Illuminate\Auth\Access\AuthorizationException
     * @throws \Exception
     */
    public function destroy(Uuid $id)
    {
        $model = self::getModel($id);
        $this->authorize('delete', $model);

        $model->delete();

        return redirect()->route(self::getModelView('index'))->with('success', "The brand <strong>{self::modelClassName()}</strong> has successfully been archived.");
    }

}