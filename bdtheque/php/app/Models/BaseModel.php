<?php

namespace BDTheque\Models;

use BDTheque\Support\ExtendedEloquentBuilder;
use BDTheque\Support\ExtendedQueryBuilder;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Str;

abstract class BaseModel extends Model implements Metadata\Base
{
    use SoftDeletes;

    public const DELETED_AT = 'deleted_at';

    public $incrementing = false;
    protected $keyType = 'string';
    protected $dates = [Model::CREATED_AT, Model::UPDATED_AT, BaseModel::DELETED_AT];

    protected static $rules = [];
    protected static $defaultOrderBy = [];
    protected static $orderBy = [];

    /**
     * Field name from which make an "initiale_$buildInitiale" field
     * @var string
     */
    protected $buildInitialeFrom = null;

    /**
     * The booting method of the model.
     *
     * @return void
     */
    public static function boot()
    {
        parent::boot();

        static::creating(function (BaseModel $model): bool {
            $model->{$model->getKeyName()} = Str::uuid()->toString();

            return true;
        });

        static::saving(function (BaseModel $model): bool {
            $keyName = $model->getKeyName();
            $original_id = $model->getOriginal($keyName);
            if ($original_id !== $model->$keyName)
                $model->$keyName = $original_id;

            if ($model->buildInitialeFrom) {
                $initiale_from_var = trim($model->buildInitialeFrom);
                $initiale_var = 'initiale_' . $initiale_from_var;

                if (empty(trim($model->$initiale_from_var)))
                    $model->$initiale_var = '#';
                else {
                    $model->$initiale_var = strtoupper(trim($model->$initiale_from_var)[0]);
                    if (!(ctype_alpha($model->$initiale_var)))
                        $model->$initiale_var = '#';
                }
            }

            return true;
        });
    }

    /**
     * @return array
     */
    public function getWith()
    {
        return $this->with;
    }

    /**
     * @return array
     */
    public static function getDefaultOrderBy(): array
    {
        return static::$defaultOrderBy;
    }

    /**
     * @return array
     */
    public static function getOrderBy(): array
    {
        return static::$orderBy;
    }

    public function newEloquentBuilder($query)
    {
        return new ExtendedEloquentBuilder($query);
    }

    protected function newBaseQueryBuilder()
    {
        $connection = $this->getConnection();

        return new ExtendedQueryBuilder(
            $connection, $connection->getQueryGrammar(), $connection->getPostProcessor()
        );
    }

    /**
     * Returns model's global validation rules
     *
     * @return array
     */
    protected static function getRules(): array
    {
        return static::$rules;
    }

    /**
     * Returns model's creation validation rules
     *
     * @return array
     */
    public static function getCreateRules(): array
    {
        return static::getRules();
    }

    /**
     * Returns model's update validation rules
     *
     * @return array
     */
    public static function getUpdateRules(): array
    {
        return static::getRules();
    }

    /**
     * @param ExtendedEloquentBuilder $query
     * @param array|object $filter
     */
    private static function addFilter($query, $filter)
    {
        if (is_object($filter)) $filter = get_object_vars($filter);
        array_change_key_case($filter, CASE_LOWER);
        $operator = array_key_exists('operator', $filter) ? $filter['operator'] : 'and';

        if (array_key_exists('c', $filter) && is_array($filter['c'])) {
            $subFilters = $filter['c'];
            $query->where(function ($q) use ($subFilters) {
                foreach ($subFilters as $key => $filter)
                    static::addFilter($q, $filter);
            }, null, null, $operator);
        } else {
            $column = $filter['column'];
            $relation = join('.', explode('.', $column, -1));

            $appendFilter = function (Builder $query, array $filter, string $column, string $operator, Model $model = null) {
                if ($model)
                    $column = $model->qualifyColumn($column);
                if (array_key_exists('value1', $filter) && array_key_exists('value2', $filter))
                    $query->whereBetween($column, [$filter['value1'], $filter['value2']], $operator);
                else
                    $query->where($column, array_key_exists('comparison', $filter) ? $filter['comparison'] : '=', $filter['value'], $operator);
            };

            if ($relation === '') {
                $appendFilter($query, $filter, $column, $operator, $query->getModel());
            } else {
                $column = substr($column, strlen($relation) + 1);
                // odd composition but needed to Builder lacks'n bug
                $query->hasRelation(
                // $query->has(
                    $relation, '>', 0, $operator,
                    function (Builder $q, Model $model) use ($query, $appendFilter, $filter, $column, $operator) {
                        $q->where(function () use ($query, $appendFilter, $filter, $column, $operator, $model) {
                            $appendFilter($query, $filter, $column, $operator, $model);
                        });
                    });
            }

        }
    }

    /**
     * @param array|object|null $filters
     * @param array|null $sortBy
     * @return Builder
     */
    public static function search($filters = null, $sortBy = null)
    {
        $query = static::query();
        assert($query instanceof ExtendedEloquentBuilder);
        $query->select($query->getModel()->qualifyColumn('*'));

        if ($filters) {
            if (is_object($filters) || (is_array($filters) && key_exists('column', $filters)))
                $filters = [$filters];
            foreach ($filters as $key => $filter)
                static::addFilter($query, $filter);
        }

        if ($sortBy) {
            $sortDirection = array_key_exists('sortDirection', $sortBy) ? $sortBy['sortDirection'] : 'asc';
            $sortBy = $sortBy['sortBy'];
        } else {
            $sortBy = null;
            $sortDirection = 'asc';
        }
        if ($sortBy && array_key_exists($sortBy, static::getOrderBy()))
            $sortBy = static::getOrderBy()[$sortBy];
        else
            $sortBy = static::getDefaultOrderBy();

        foreach ($sortBy as $column) {
            $query->orderByRelation($column, $sortDirection);
        }

        return $query;
    }

}
