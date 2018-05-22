<?php

use BDTheque\Models\Editeur;
use Faker\Generator as Faker;

/**
 * @var \Illuminate\Database\Eloquent\Factory $factory
 */
$factory->define(Editeur::class, function (Faker $faker) {
    return [
        'nom_editeur' => $faker->unique()->text(50)
    ];
});
