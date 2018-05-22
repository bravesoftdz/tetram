<?php

use BDTheque\Models\Genre;
use Faker\Generator as Faker;

/**
 * @var \Illuminate\Database\Eloquent\Factory $factory
 */
$factory->define(Genre::class, function (Faker $faker) {
    return [
        'genre' => $faker->unique()->text(30)
    ];
});
