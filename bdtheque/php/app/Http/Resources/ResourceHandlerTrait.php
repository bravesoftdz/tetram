<?php

namespace BDTheque\Http\Resources;


trait ResourceHandlerTrait
{
    private $parentResource = null;
    private $fullResource = false;

    /**
     * @return bool
     */
    public function isFullResource(): bool
    {
        return $this->fullResource;
    }

    /**
     * @return BaseModelResource|null
     */
    public function getRootResource(): ?BaseModelResource
    {
        $root = $this->getParentResource();
        if ($root)
            while ($root->getParentResource())
                $root = $root->getParentResource();
        return $root;
    }

    /**
     * @return BaseModelResource|null
     */
    public function getParentResource(): ?BaseModelResource
    {
        return $this->parentResource;
    }
}