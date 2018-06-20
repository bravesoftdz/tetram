<?php

namespace BDTheque\Http\Controllers;

use BDTheque\Models\BaseModelHandlerTrait;
use BDTheque\Support\ExtendedEloquentBuilder;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

trait BaseModelControllerTrait
{
    use BaseModelHandlerTrait;
    static $baseModelHandlerSuffix = 'Controller';
    static $DEFAULT_ROWS_PER_PAGE = 15;

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
     * @param array|null $scopes
     * @return Model
     */
    protected static function getModel(string $id, ?array $scopes = null): Model
    {
        $modelClass = self::getModelClass();
        /** @var ExtendedEloquentBuilder $query */
        $query = (new $modelClass)->newQuery();
        if ($scopes)
            foreach($scopes as $_ => $scope)
                $query->$scope();
        return $query->findOrFail($id);
    }

}