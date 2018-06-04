<?php

use BDTheque\Faker\Provider\ModelProvider;
use BDTheque\Models\Univers;
use BDTheque\Support\ExtendedEloquentBuilder as EloquentBuilder;
use Faker\Generator as Faker;

/**
 * @var \Illuminate\Database\Eloquent\Factory $factory
 */
$factory->define(Univers::class, function (Faker $faker) {
    $faker->addProvider(new ModelProvider($faker));

    return [
        'nom_univers' => $faker->unique()->text(50),
    ];
})->afterCreating(Univers::class, function (Univers $univers, Faker $faker) {
    $univers
        ->univers_parent()->associate(
            $faker->optional(25)->randomModel(Univers::class, function (EloquentBuilder $query) use ($univers, $faker) {
                $query->whereKeyNot($univers->id);
                if ($faker->boolean(30)) {
                    $query->whereNotNull('parent_univers_id')->whereNotNull('racine_univers_id');
                    if ($faker->boolean(30)) {
                        $query->whereColumn('parent_univers_id', '<>', 'racine_univers_id');
                    }
                }
            }))
        ->save();
});