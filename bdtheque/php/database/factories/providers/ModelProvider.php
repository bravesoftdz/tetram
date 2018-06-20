<?php

namespace BDTheque\Faker\Provider;

use BDTheque\Models\BaseModel;
use Closure;
use Faker\Provider\Base;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

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

    /**
     * @param BelongsToMany $list
     * @param string $class
     * @param int $chancesOfNotEmpty
     * @param int $min
     * @param int $max
     * @param Closure|null $wheres
     * @param Closure|null $callback
     */
    public function randomModels(BelongsToMany $list, string $class, int $chancesOfNotEmpty = 75, int $min = 1, int $max = 3, ?Closure $wheres = null, ?Closure $callback = null)
    {
        $c = $this->generator->boolean($chancesOfNotEmpty) ? $this->numberBetween($min, $max) : 0;

        $items = [];
        while ($c-- > 0) {
            $model = $this->randomModel($class, $wheres);
            if ($model) {
                if ($callback) {
                    $items += [$model->id => $callback($model)];
                } else {
                    $items += [$model->id];
                }
            }
        }

        $list->sync($items);
    }

    public function randomEnum(string $enum)
    {
        $enums = config('enum');
        if (!(array_key_exists($enum, $enums)))
            return null;

        $enums = $enums[$enum]['values'];
        return $enums[$this->numberBetween(0, count($enums) - 1)];
    }
}