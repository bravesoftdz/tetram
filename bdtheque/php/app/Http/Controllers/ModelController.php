<?php

namespace BDTheque\Http\Controllers;


abstract class ModelController extends Controller
{
    use BaseModelControllerTrait;

    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return view(self::getModelView('index'));
    }

    /**
     * Display the specified resource.
     *
     * @param string $id
     * @return \Illuminate\Http\Response
     */
    public function show(string $id)
    {
        return view(self::getModelView('show'))->with(self::getModelViewTag(), self::getModel($id));
    }

}