<?php

namespace BDTheque\Http\Resources;

use Illuminate\Contracts\Pagination\LengthAwarePaginator as LengthAwarePaginatorIntf;
use Illuminate\Http\Resources\Json\ResourceCollection;
use Illuminate\Http\Resources\MissingValue;
use Illuminate\Pagination\AbstractPaginator;
use Illuminate\Pagination\LengthAwarePaginator as LengthAwarePaginatorImpl;

class BaseModelResourceCollection extends ResourceCollection
{
    use ResourceHandlerTrait;

    private $pagination;

    /**
     * BaseModelResourceCollection constructor.
     * @param LengthAwarePaginatorImpl|LengthAwarePaginatorIntf $resource
     * @param bool $full
     * @param BaseModelResource|null $parent
     */
    public function __construct($resource, bool $full, ?BaseModelResource $parent = null)
    {
        $this->fullResource = $full;
        $this->parentResource = $parent;

        // should always be as $resouce is hintyped, but may be extend to handle resource collection (without pagination)
        if (is_a($resource, LengthAwarePaginatorImpl::class)) {
            $this->pagination = [
                'total' => $resource->total(),
                'count' => $resource->count(),
                'per_page' => $resource->perPage(),
                'current_page' => $resource->currentPage(),
                'total_pages' => $resource->lastPage()
            ];

            $resource = $resource->getCollection();
        }

        parent::__construct($resource);
    }

    /**
     * Map the values into a new class.
     *
     * @param $collection
     * @param  string $class
     * @return static
     */
    public function mapInto($collection, $class)
    {
        return $collection->map(function ($value, $key) use ($class) {
            return new $class($value, $this->isFullResource(), $this->getParentResource());
        });
    }

    /**
     * Map the given collection resource into its individual resources.
     *
     * @param  mixed $resource
     * @return mixed
     */
    protected function collectResource($resource)
    {
        if ($resource instanceof MissingValue) {
            return $resource;
        }

        $collects = $this->collects();

        $this->collection = $collects && !$resource->first() instanceof $collects
            ? $this->mapInto($resource, $collects)
            : $resource->toBase();

        return $resource instanceof AbstractPaginator
            ? $resource->setCollection($this->collection)
            : $this->collection;
    }


    /**
     * Transform the resource collection into an array.
     *
     * @param  \Illuminate\Http\Request $request
     * @return array|\Illuminate\Support\Collection
     */
    public function toArray($request)
    {
        if (!$this->getParentResource())
            return [
                'data' => $this->collection,
                'pagination' => $this->pagination
            ];

        return $this->collection;
    }
}