<?php

namespace BDTheque\Support;

use Closure;
use Illuminate\Database\Eloquent\Builder as EloquentBuilder;
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

        $closure = function ($q) use (&$closure, &$relations, $operator, $count, $callback) {
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
     * same as "has" method but will use join when $relation is "joinable"
     *
     * @param string $relation
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

        $relation = $this->getRelationWithoutConstraints($relation);

        if (!self::isRelationJoinable($relation))
            return $this->has($relation, $operator, $count, $boolean, $callback);

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
     * @return $this
     */
    public function orderByRelation(string $column, string $direction = 'asc')
    {
        if ($this->isRawColumn($column))
            return $this->orderBy(DB::raw($column), $direction);

        $model = $this->getModel();

        if (strpos($column, '.') !== false) {
            $query = $this;
            $columns = explode('.', $column);
            $column = array_pop($columns);
            foreach ($columns as $c) {
                $relation = $query->getRelationWithoutConstraints($c);

                if (self::isRelationJoinable($relation)) {
                    // it looks like the relation can be joined
                    $query = $relation->getRelationExistenceQuery($relation->getRelated()->newQuery(), $this)->applyScopes();
                    $model = $query->getModel();
                    $this->addJoinRelation($query);
                }
            }
        }

        if ($model)
            $column = $model->qualifyColumn($column);
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

}