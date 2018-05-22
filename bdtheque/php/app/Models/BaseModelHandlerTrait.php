<?php

namespace BDTheque\Models;

trait BaseModelHandlerTrait
{
    protected static $modelClass;
    protected static $modelResourceClass;
    protected static $modelResourceCollectionClass;
    // it's not allowed for a trait to override another trait field
    //    protected static $baseModelHandlerSuffix = '';

    /**
     * Returns the Model class name handled by the class using this trait
     *
     * @param string|null $class
     * @return string
     */
    protected static function getModelClassName(string $class = null): string
    {
        $classPath = explode('\\', $class ?: static::$modelClass ?: get_called_class());
        $className = end($classPath);
        if (!$class && !static::$modelClass) {
            $className = substr($className, 0, strlen($className) - strlen(static::getBaseModelHandlerSuffix()));
            $className = str_singular($className);
        }
        return $className;
    }

    /**
     * Returns the Model class handled by the class using this trait
     *
     * @return string|BaseModel
     */
    protected static function getModelClass(): string
    {
        if (static::$modelClass) return static::$modelClass;

        return $className = '\\BDTheque\\Models\\' . static::getModelClassName();
    }

    /**
     * Returns the ModelResource class handled by the class using this trait
     *
     * @param string|null $class
     * @return string
     */
    protected static function getModelResourceClass(string $class = null): string
    {
        if (!$class && static::$modelResourceClass) return static::$modelResourceClass;

        return $className = '\\BDTheque\\Http\\Resources\\' . static::getModelClassName($class) . 'Resource';
    }

    /**
     * Returns the ModelResourceCollection class handled by the class using this trait
     *
     * @param string|null $class
     * @return string
     */
    protected static function getModelResourceCollectionClass(string $class = null): string
    {
        if (!$class && static::$modelResourceCollectionClass) return static::$modelResourceCollectionClass;

        return $className = static::getModelResourceClass($class) . 'Collection';
    }

    /**
     * @return string
     */
    protected static function getBaseModelHandlerSuffix()
    {
        if (static::$baseModelHandlerSuffix) return static::$baseModelHandlerSuffix;

        return '';
    }


}