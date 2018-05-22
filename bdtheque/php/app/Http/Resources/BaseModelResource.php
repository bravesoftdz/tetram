<?php

namespace BDTheque\Http\Resources;

use BDTheque\Models\Metadata\Base;
use Illuminate\Http\Resources\Json\JsonResource;

abstract class BaseModelResource extends JsonResource implements Base
{
    private $fullResource = false;

    /**
     * BaseModelResource constructor.
     * @param mixed $resource
     * @param bool $full
     */
    public function __construct($resource, bool $full)
    {
        $this->fullResource = $full;
        parent::__construct($resource);
    }

    /**
     * @return bool
     */
    public function isFullResource(): bool
    {
        return $this->fullResource;
    }

    public function toArray($request)
    {
        return [
            'id' => $this->id
        ];
    }
}