<?php

namespace BDTheque\Http\Resources;

use Illuminate\Contracts\Pagination\LengthAwarePaginator as LengthAwarePaginatorIntf;
use Illuminate\Http\Resources\Json\ResourceCollection;
use Illuminate\Pagination\LengthAwarePaginator as LengthAwarePaginatorImpl;

abstract class BaseModelResourceCollection extends ResourceCollection
{
    private $pagination;

    /**
     * BaseModelResourceCollection constructor.
     * @param LengthAwarePaginatorImpl|LengthAwarePaginatorIntf $resource
     */
    public function __construct($resource)
    {
        // should always be as $resouce is hintype, but may be extend to handle resource collection (without pagination)
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
     * Transform the resource collection into an array.
     *
     * @param  \Illuminate\Http\Request $request
     * @return array
     */
    public function toArray($request)
    {
        return [
            'data' => $this->collection,
            'pagination' => $this->pagination
        ];
    }
}