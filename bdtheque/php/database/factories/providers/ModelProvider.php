<?php

namespace BDTheque\Faker\Provider;

use BDTheque\Models\BaseModel;
use Faker\Provider\Base;

class ModelProvider extends Base
{
    /**
     * @param string $class
     * @param array $wheres
     * @return BaseModel
     */
    public function randomModel(string $class, array $wheres = []): BaseModel
    {
        return (new $class)->inRandomOrder()->where($wheres)->limit(1)->first();
    }
}