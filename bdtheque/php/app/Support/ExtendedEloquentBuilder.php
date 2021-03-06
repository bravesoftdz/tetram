<?php

namespace BDTheque\Support;

use BDTheque\Models\BaseModel;
use Closure;
use Illuminate\Database\Eloquent\Builder as EloquentBuilder;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasOne;
use Illuminate\Database\Eloquent\Relations\MorphOne;
use Illuminate\Database\Eloquent\Relations\MorphTo;
use Illuminate\Database\Eloquent\Relations\Relation;
use Illuminate\Database\Query\JoinClause;
use Illuminate\Support\Facades\DB;

class ExtendedEloquentBuilder extends EloquentBuilder
{
    /**
     * @return ExtendedQueryBuilder|\Illuminate\Database\Query\Builder
     */
    public function toBase()
    {
        return parent::toBase();
    }

    /**
     * change model reference without changing from query
     *
     * @param Model $model
     * @return $this
     */
    public function changeModel(Model $model)
    {
        $this->model = $model;
        return $this;
    }

    /**
     * @param Relation $relation
     * @return bool
     */
    private static function isRelationJoinable(Relation $relation): bool
    {
        return
            ($relation instanceof BelongsTo) ||
            ($relation instanceof HasOne) ||
            ($relation instanceof MorphTo) ||
            ($relation instanceof MorphOne);
    }

    /**
     * @param  string $relation
     * @param  \Closure|null $callback
     * @param  string $operator
     * @param  int $count
     * @return \Illuminate\Database\Eloquent\Builder|static
     */
    public function whereHasRelation($relation, Closure $callback = null, $operator = '>=', $count = 1)
    {
        return $this->hasRelation($relation, $operator, $count, 'and', $callback);
    }

    /**
     * @param  string $relations
     * @param  string $operator
     * @param  int $count
     * @param  string $boolean
     * @param  \Closure|null $callback
     * @return \Illuminate\Database\Eloquent\Builder|static
     */
    protected function hasNestedRelation($relations, $operator = '>=', $count = 1, $boolean = 'and', $callback = null)
    {
        $relations = explode('.', $relations);

        $closure = function () use (&$closure, &$relations, $operator, $count, $callback) {
            // In order to nest "has", we need to add count relation constraints on the
            // callback Closure. We'll do this by simply passing the Closure its own
            // reference to itself so it calls itself recursively on each segment.
            count($relations) > 1
                ? $this->whereHasRelation(array_shift($relations), $closure)
                : $this->hasRelation(array_shift($relations), $operator, $count, 'and', $callback);
        };

        return $this->hasRelation(array_shift($relations), '>=', 1, $boolean, $closure);
    }

    /**
     * @param  string $relations
     * @param  \Closure|null $callback
     * @return \Illuminate\Database\Eloquent\Builder|static
     */
    protected function joinNestedRelation($relations, $callback = null)
    {
        $relations = explode('.', $relations);

        $closure = function () use (&$closure, &$relations, $callback) {
            // In order to nest "join", we need to add count relation constraints on the
            // callback Closure. We'll do this by simply passing the Closure its own
            // reference to itself so it calls itself recursively on each segment.
            count($relations) > 1
                ? $this->whereHasRelation(array_shift($relations), $closure)
                : $this->hasRelation(array_shift($relations), $callback);
        };

        return $this->joinRelation(array_shift($relations), $closure);
    }

    /**
     * same as "has" method but will use join when $relation is "joinable"
     *
     * @param string $relation_inst
     * @param string $operator
     * @param int $count
     * @param string $boolean
     * @param Closure|null $callback
     * @return $this|EloquentBuilder|static
     */
    public function hasRelation($relation, $operator = '>=', $count = 1, $boolean = 'and', Closure $callback = null)
    {
        if (strpos($relation, '.') !== false) {
            return $this->hasNestedRelation($relation, $operator, $count, $boolean, $callback);
        }

        $relation_inst = $this->getRelationWithoutConstraints($relation);

        if (!self::isRelationJoinable($relation_inst))
            return $this->has($relation, $operator, $count, $boolean, function (EloquentBuilder $q) use ($relation_inst, $callback){
                if ($callback)
                    $callback($q->getQuery(), false, $relation_inst->getModel());
            });

        // it looks like the relation can be joined
        $this->addJoinRelation($relation_inst->getRelationExistenceQuery($relation_inst->getRelated()->newQuery(), $this)->applyScopes());
        if ($callback)
            $this->callScope($callback, [true, $relation_inst->getModel()]);

        return $this;
    }

    /**
     * same as "has" method but will use join when $relation is "joinable"
     *
     * @param string $relation
     * @param Closure|null $callback
     * @return $this
     */
    public function joinRelation($relation, $callback = null)
    {
        if (strpos($relation, '.') !== false) {
            return $this->joinNestedRelation($relation, $callback);
        }

        $relation = $this->getRelationWithoutConstraints($relation);

        if (!self::isRelationJoinable($relation))
            return $this;

        // it looks like the relation can be joined
        $this->addJoinRelation($relation->getRelationExistenceQuery($relation->getRelated()->newQuery(), $this)->applyScopes());
        if ($callback)
            $this->callScope($callback, [$relation->getModel()]);

        return $this;
    }

    /**
     * @param string $column
     * @return bool
     */
    private function isRawColumn(string $column)
    {
        for ($i = 0; $i < strlen($column); $i++) {
            $c = $column[$i];
            if (!ctype_alnum($c) && $c !== '_' && $c !== '.')
                return true;
        }
        return false;
    }

    /**
     * @param string $column
     * @param string $direction
     * @param null|string $table
     * @return $this
     */
    public function orderByRelation(string $column, string $direction = 'asc', ?string $table = null)
    {
        if ($this->isRawColumn($column))
            return $this->orderBy(DB::raw($column), $direction);

        $modelTable = $table ?: $this->getModel()->getTable();

        if (strpos($column, '.') !== false) {
            $query = $this;
            $columns = explode('.', $column);
            $column = array_pop($columns);
            foreach ($columns as $c) {
                $relation = $query->getRelationWithoutConstraints($c);

                if (self::isRelationJoinable($relation)) {
                    // it looks like the relation can be joined
                    $query = $relation->getRelationExistenceQuery($relation->getRelated()->newQuery(), $this)->applyScopes();
                    $modelTable = $query->toBase()->getAliasTable($query->toBase()->from);
                    $this->addJoinRelation($query);
                }
            }
        }

        if ($modelTable)
            $column = "$modelTable.$column";
        return $this->orderBy($column, $direction);
    }

    /**
     * @param EloquentBuilder $query
     * @return ExtendedEloquentBuilder|\Illuminate\Database\Query\Builder
     */
    private function addJoinRelation($query)
    {
        $table = $query->getQuery()->from;
        $wheres = $query->getQuery()->wheres;
        $bindings = $query->getQuery()->bindings;

        if ($this->getQuery()->joins)
            /** @var JoinClause $join */
            foreach ($this->getQuery()->joins as $join) {
                $sameJoin = $join->from ? ($join->from === $this->getQuery()->from) : true;
                $sameJoin = $sameJoin && ($join->table === $table);
                // should check "wheres" but this is enough for now
                if ($sameJoin) return $this;
            }

        return $this->leftJoin($table, function (JoinClause $q) use ($wheres, $bindings) {
            $q->on(function (JoinClause $q) use ($wheres, $bindings) {
                $q->mergeWheres($wheres, $bindings);
            });
        });
    }

    /**
     * @param string|null $sortBy
     * @param string $sortDirection
     * @param string|null $table
     * @return ExtendedEloquentBuilder
     */
    public function orderByRef(?string $sortBy = null, string $sortDirection = 'asc', ?string $table = null)
    {
        /** @var BaseModel $modelClass */
        $modelClass = get_class($this->getModel());
        if ($sortBy && array_key_exists($sortBy, $modelClass::getOrderBy()))
            $sortBy = $modelClass::getOrderBy()[$sortBy];
        else
            $sortBy = $modelClass::getDefaultOrderBy();
        foreach ($sortBy as $column) {
            $this->orderByRelation($column, $sortDirection, $table);
        }
        return $this;
    }

}