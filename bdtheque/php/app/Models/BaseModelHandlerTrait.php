<?php

namespace BDTheque\Models;


trait BaseModelHandlerTrait
{
    protected static $modelClass;
//    protected static $baseModelHandlerSuffix = '';

    /**
     * Returns the Model class name handled by the class using this trait
     *
     * @return string
     */
    protected static function getModelClassName(): string
    {
        $classPath = explode('\\', (self::$modelClass ? self::$modelClass : get_called_class()));
        $className = end($classPath);
        if (!self::$modelClass) {
            $className = substr($className, 0, strlen($className) - strlen(self::getBaseModelHandlerSuffix()));
            $className = str_singular($className);
        }
        return $className;
    }

    /**
     * Returns the Model class handled by the class using this trait
     *
     * @return string
     */
    protected static function getModelClass(): string
    {
        if (self::$modelClass) return self::$modelClass;

        return $className = '\\BDTheque\\Models\\' . self::getModelClassName();
    }

    /**
     * @return string
     */
    protected static function getBaseModelHandlerSuffix()
    {
        if (self::$baseModelHandlerSuffix) return self::$baseModelHandlerSuffix;

        return '';
    }


}