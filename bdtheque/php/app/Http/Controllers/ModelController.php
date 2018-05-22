<?php

namespace BDTheque\Http\Controllers;


use BDTheque\Http\Resources\BaseModelResourceCollection;
use BDTheque\Models\BaseModel;
use BDTheque\Support\ExtendedEloquentBuilder;
use Illuminate\Database\Eloquent\Builder as EloquentBuilder;
use Illuminate\Database\Eloquent\RelationNotFoundException;
use Illuminate\Http\Request;

abstract class ModelController extends Controller
{
    use BaseModelControllerTrait;

    /**
     * @returns integer
     */
    protected function getRowPerPage()
    {
        return (Integer)request()->query->get('perPage', static::$DEFAULT_ROWS_PER_PAGE);
    }

    /**
     * @param Request $request
     * @return ExtendedEloquentBuilder|EloquentBuilder
     */
    protected function search(Request $request)
    {
        return static::getModelClass()::search($request->json()->get('filters'), $request->json()->get('sortBy'));
    }

    /**
     * @param Request $request
     * @return BaseModelResourceCollection
     */
    public function index(Request $request)
    {
        $results = $this->search($request);

        $groupBy = $request->json()->get('groupBy');
        if ($groupBy) {
            $sortBy = $request->json()->get('groupBySort');
            if ($sortBy) {
                $sortDirection = array_key_exists('sortDirection', $sortBy) ? $sortBy['sortDirection'] : 'asc';
                $sortBy = $sortBy['sortBy'];
            } else {
                $sortBy = null;
                $sortDirection = 'asc';
            }

            $results->distinct()->setEagerLoads([]);

            try {
                $relation = $results->getRelation($groupBy);

                /** @var BaseModel $modelClass */
                $modelClass = get_class($relation->getModel());
                $relation->with($modelClass::getAutoLoadRelations());
                $results->select($relation->getForeignKey());
                $relation->addEagerConstraints($results->getModels());

                if ($sortBy && array_key_exists($sortBy, $modelClass::getOrderBy()))
                    $sortBy = $modelClass::getOrderBy()[$sortBy];
                else
                    $sortBy = $modelClass::getDefaultOrderBy();
                foreach ($sortBy as $column) {
                    $relation->getQuery()->orderByRelation($column, $sortDirection);
                }

                $results = $relation->getQuery();
            } catch (RelationNotFoundException $e) {
                // groupBy is not relation: assumes it's a current model field
                $results->select($results->getModel()->qualifyColumn($groupBy));
                $results->setQuery($results->getQuery()->cloneWithout(['orders']));
                $results->orderBy($groupBy, $sortDirection);
            }
        }

        $modelResourceCollectionClass = static::getModelResourceCollectionClass(get_class($results->getModel()));
        return new $modelResourceCollectionClass($results->paginate($this->getRowPerPage()));
    }

    /**
     * Display the specified resource.
     *
     * @param string $id
     * @return \Illuminate\Http\Response
     */
    public function show(string $id)
    {
        return view(static::getModelView('show'))->with(static::getModelViewTag(), static::getModel($id));
    }

}