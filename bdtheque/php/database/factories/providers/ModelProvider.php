<?php

namespace BDTheque\Faker\Provider;

use BDTheque\Models\BaseModel;
use Closure;
use Faker\Provider\Base;

class ModelProvider extends Base
{
    /**
     * @param string $class
     * @param Closure|null $wheres
     * @return BaseModel|null
     */
    public function randomModel(string $class, ?Closure $wheres = null): ?BaseModel
    {
        /** @var BaseModel $model */
        $model = (new $class);
        $query = $model->newModelQuery();

        if ($wheres instanceof Closure)
            $wheres($query);

        return $query->inRandomOrder()->limit(1)->first();
    }
}