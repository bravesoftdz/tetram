<?php

namespace BDTheque\Http\Controllers;

use BDTheque\Models\BaseModelHandlerTrait;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

trait BaseModelControllerTrait
{
    use BaseModelHandlerTrait;
    static $baseModelHandlerSuffix = 'Controller';

    /**
     * Returns the tag used in view files to identify the related model class name
     *
     * @return string
     */
    protected static function getModelViewTag(): string
    {
        return Str::snake(self::getModelClassName());
    }

    /**
     * Return the view name related to the model class name
     *
     * @param string $view
     * @return string
     */
    protected static function getModelView(string $view): string
    {
        return self::getModelViewTag() . '.' . $view;
    }

    /**
     * @param string $id
     * @return Model
     */
    protected static function getModel(string $id): Model
    {
        $modelClass = self::getModelClass();
        return $modelClass::findOrFail($id);
    }

}