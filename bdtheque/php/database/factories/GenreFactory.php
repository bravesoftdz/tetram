<?php

use Faker\Generator as Faker;

$factory->define(\BDTheque\Models\Genre::class, function (Faker $faker) {
    return [
        'genre' => $faker->text(30)
    ];
});
