<?php

namespace BDTheque\Http\Controllers;


use BDTheque\Models\BaseModel;
use Illuminate\Support\Str;

trait TraitModelController
{
    protected static $modelClass;

    /**
     * Returns the Model class name handled by the controller
     *
     * @return string
     */
    protected static function getModelClassName(): string
    {
        $classPath = explode('\\', (self::$modelClass ? self::$modelClass : get_called_class()));
        $className = end($classPath);
        if (!self::$modelClass) {
            $className = substr($className, 0, strlen($className) - strlen('Controller'));
            $className = str_singular($className);
        }
        return $className;
    }

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
     * Returns the Model class handled by the controller
     *
     * @return string
     */
    protected static function getModelClass(): string
    {
        if (self::$modelClass) return self::$modelClass;

        return $className = 'BDTheque\\Models\\' . self::getModelClassName();
    }

    /**
     * @param string $id
     * @return BaseModel
     */
    protected static function getModel(string $id): BaseModel
    {
        $modelClass = self::getModelClass();
        return $modelClass::find($id) ?? abort(404);
    }

}