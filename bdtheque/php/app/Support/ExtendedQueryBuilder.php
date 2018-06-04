<?php

namespace BDTheque\Support;

use Illuminate\Database\Query\Builder as QueryBuilder;

class ExtendedQueryBuilder extends QueryBuilder
{
    /**
     * Run a pagination count query.
     *
     * @param  array $columns
     * @return array
     */
    protected function runPaginationCountQuery($columns = ['*'])
    {
        return (new static($this->getConnection()))
            ->fromSub($this->cloneWithout(['orders', 'limit', 'offset'])->cloneWithoutBindings(['order']), 't')
            ->setAggregate('count', ['*'])
            ->get()->all();

//        return $this->cloneWithout(['columns', 'orders', 'limit', 'offset'])
//            ->cloneWithoutBindings(['select', 'order'])
//            ->setAggregate('count', $this->withoutSelectAliases($columns))
//            ->get()->all();
    }

    /**
     * @param string $table
     * @return string
     */
    public function getRawTable($table)
    {
        return str_contains($table, ' as ') ? explode(' as ', $table)[0] : $table;
    }

    /**
     * @param string $table
     * @return string
     */
    public function getAliasTable($table)
    {
        return str_contains($table, ' as ') ? explode(' as ', $table)[1] : $table;
    }

}