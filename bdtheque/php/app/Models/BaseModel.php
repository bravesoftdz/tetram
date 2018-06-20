<?php

namespace BDTheque\Models;

use BDTheque\Support\ExtendedEloquentBuilder;
use BDTheque\Support\ExtendedQueryBuilder;
use Illuminate\Database\Eloquent\Builder as EloquentBuilder;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Query\Builder as QueryBuilder;
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
    protected $withFull = [];

    /**
     * Field name from which make an "initiale_$buildInitiale" field
     * @var string
     */
    protected $buildInitialeFrom = null;

    /**
     * @return string
     */
    public function getInitialeFieldName()
    {
        return $this->buildInitialeFrom ? 'initiale_' . trim($this->buildInitialeFrom) : '';
    }


    protected function checkId()
    {
        $keyName = $this->getKeyName();
        $original_id = $this->getOriginal($keyName);
        if ($original_id)
            $this->$keyName = $original_id;
        else if (!$this->$keyName)
            $this->$keyName = Str::uuid()->toString();
    }

    /**
     * The booting method of the model.
     *
     * @return void
     */
    public static function boot()
    {
        parent::boot();

        static::creating(function (BaseModel $model): ?bool {
            $model->checkId();

            // return null to allow other events to be fired
            return null;
        });

        static::saving(function (BaseModel $model): ?bool {
            $model->checkId();

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

            // return null to allow other events to be fired
            return null;
        });
    }

    /**
     * @param \Illuminate\Database\Eloquent\Builder $query
     * @return \Illuminate\Database\Eloquent\Builder
     */
    public function scopeFull($query)
    {
//        $constraint = function ($relation) {
//            $relation->full();
//        };
//
//        foreach($this->getWith() as $id => $relation)
//            $query->with([$relation => $constraint]);
//        foreach($this->getWithFull() as $id => $relation)
//            $query->with([$relation => $constraint]);
//        return $query;

        // $this->getWith should already be prepared for eager load
        return $query->with($this->getWith())->with($this->getWithFull());
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
    public function getWithFull()
    {
        return $this->withFull;
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
     * @param ExtendedEloquentBuilder|null $rootQuery
     */
    private static function addFilter($query, $filter, $rootQuery = null)
    {
        if (!$rootQuery)
            $rootQuery = $query;

        if (is_object($filter)) $filter = get_object_vars($filter);
        array_change_key_case($filter, CASE_LOWER);
        $operator = array_key_exists('operator', $filter) ? $filter['operator'] : 'and';

        if (array_key_exists('c', $filter) && is_array($filter['c'])) {
            $subFilters = $filter['c'];
            $query->where(function ($q) use ($subFilters, $rootQuery) {
                foreach ($subFilters as $key => $filter)
                    static::addFilter($q, $filter, $rootQuery);
            }, null, null, $operator);
        } else {
            $column = $filter['column'];
            $relation = join('.', explode('.', $column, -1));

            /**
             * @param QueryBuilder | EloquentBuilder $query
             * @param array $filter
             * @param string $column
             * @param string $operator
             * @param Model|null $model
             */
            $appendFilter = function ($query, array $filter, string $column, string $operator, Model $model = null) {
                if ($model)
                    $column = $model->qualifyColumn($column);
                $comparison = array_key_exists('comparison', $filter) ? strtolower($filter['comparison']) : '=';
                switch ($comparison) {
                    case 'between':
                    case 'not between':
                        $query->whereBetween($column, [$filter['value1'], $filter['value2']], $operator, $comparison === 'not between');
                        break;
                    case 'not in':
                    case 'in':
                        $query->whereIn($column, $filter['value'], $operator, $comparison === 'not in');
                        break;
                    default:
                        $query->where($column, $comparison, $filter['value'], $operator);
                }
            };

            if ($relation === '') {
                $appendFilter($query, $filter, $column, $operator, $query->getModel());
            } else {
                $column = substr($column, strlen($relation) + 1);
                // odd composition but needed to Builder lacks'n bug
                $rootQuery->hasRelation(
                    $relation, '>', 0, $operator,
                    /**
                     * @param QueryBuilder | EloquentBuilder $q
                     * @param bool $joinUsed
                     * @param Model $model
                     */
                    function ($q, bool $joinUsed, Model $model) use ($query, $appendFilter, $filter, $column, $operator) {
                        $query = $joinUsed ? $query : $q;
                        $operator = $joinUsed ? $operator : 'and';
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
     * @return EloquentBuilder
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

        if (is_string($sortBy))
            $sortBy = ['sortBy' => $sortBy];

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
