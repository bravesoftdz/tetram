<?php

use BDTheque\Faker\Provider\AuthorProvider;
use BDTheque\Models\Personne;
use Faker\Generator as Faker;

/**
 * @var \Illuminate\Database\Eloquent\Factory $factory
 */
$factory->define(Personne::class, function (Faker $faker) {
    $faker->addProvider(new AuthorProvider($faker));

    return [
        'nom_personne' => $faker->unique()->authorName(),
        'biographie' => $faker->optional(10)->text(500)
    ];
});
