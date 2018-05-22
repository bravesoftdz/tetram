<?php

use BDTheque\Faker\Provider\ModelProvider;
use BDTheque\Models\Collection;
use BDTheque\Models\Editeur;
use Faker\Generator as Faker;

/**
 * @var \Illuminate\Database\Eloquent\Factory $factory
 */
$factory->define(Collection::class, function (Faker $faker) {
    $faker->addProvider(new ModelProvider($faker));

    return [
        'nom_collection' => $faker->unique()->text(50), // should by unique against editeur_id
        'editeur_id' => $faker->randomModel(Editeur::class)->id
    ];
});
