<?php

namespace BDTheque\Http\Controllers\Admin;


use BDTheque\Http\Controllers\BaseModelControllerTrait;
use BDTheque\Http\Controllers\Controller;
use BDTheque\Http\Requests\BaseModelRequest;
use BDTheque\Models\BaseModel;
use Illuminate\Auth\Access\AuthorizationException;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Response;

abstract class AdminController extends Controller
{
    use BaseModelControllerTrait;

    /**
     * Show the form for creating a new resource.
     *
     * @return Response
     */
    public function _create()
    {
        return view()->first([self::getModelView('create'), self::getModelView('edit')])->with(self::getModelViewTag(), null);
    }

    /**
     * Edit the specified resource.
     *
     * @param Model $model
     * @return Response
     */
    public function _edit(Model $model)
    {
        return view(self::getModelView('edit'))->with(self::getModelViewTag(), $model);
    }

    /**
     * Display the specified resource.
     *
     * @param Model $model
     * @return Response
     */
    public function _delete(Model $model)
    {
        return view(self::getModelView('delete'))->with(self::getModelViewTag(), self::getModel($model));
    }

    /**
     * Create a new resource in storage
     *
     * @param BaseModelRequest $request
     * @return RedirectResponse
     * @throws AuthorizationException
     */
    public function _store(BaseModelRequest $request)
    {
        $modelClass = self::getModelClass();
        /** @var BaseModel $model */
        $model = new $modelClass($request->all());
        $this->authorize('create', $model);
        $model->save();

        return back()->with('success', "The brand <strong>{self::modelClassName()}</strong> has successfully been created.");
    }

    /**
     * Update the specified resource in storage.
     *
     * @param BaseModelRequest $request
     * @param Model $model
     * @return Response
     * @throws AuthorizationException
     */
    public function _update(BaseModelRequest $request, Model $model)
    {
        $this->authorize('update', $model);
        $model->update($request->all());

        return back()->with('success', "The brand <strong>{self::modelClassName()}</strong> has successfully been updated.");
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param Model $model
     * @return Response
     * @throws AuthorizationException
     * @throws \Exception
     */
    public function _destroy(Model $model)
    {
        $this->authorize('delete', $model);
        $model->delete();

        return back()->with('success', "The brand <strong>{self::modelClassName()}</strong> has successfully been archived.");
    }

}