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
                /** @var BaseModel $model */
                $model = $relation->getModel();

                $results->joinRelation($groupBy);
                $results->changeModel($model);
                $results->with($model->getWith());
                $results->setQuery($results->getQuery()->cloneWithout(['orders']));

                $relationAlias = null;
                foreach ($results->getQuery()->joins as $join) {
                    $table = $results->toBase()->getRawTable($join->table);
                    if ($table === $relation->getQuery()->toBase()->from)
                        $relationAlias = $results->toBase()->getAliasTable($join->table);
                }
                $results->select("$relationAlias.*");
                $results->orderByRef($sortBy, $sortDirection, $relationAlias);

            } catch (RelationNotFoundException $e) {
                // groupBy is not relation: assumes it's a current model field
                $results->select($results->getModel()->qualifyColumn($groupBy));
                $results->setQuery($results->getQuery()->cloneWithout(['orders']));
                $results->orderBy($groupBy, $sortDirection);
            }
        }

        $modelResourceCollectionClass = static::getModelResourceCollectionClass(get_class($results->getModel()));
        if ($this->getRowPerPage() === -1)
            return new $modelResourceCollectionClass($results->get(), false);
        else
            return new $modelResourceCollectionClass($results->paginate($this->getRowPerPage()), false);
    }

    /**
     * @param string $itemId
     * @return \Illuminate\Database\Eloquent\Model
     */
    public function get(Request $request, string $itemId){
        $fullItem = $request->has('full');
        $model = static::getModel($itemId, $fullItem ? ['full'] : []);
        $modelResourceClass = static::getModelResourceClass();
        return new $modelResourceClass($model, $fullItem);
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