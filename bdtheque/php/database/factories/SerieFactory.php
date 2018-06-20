<?php

use BDTheque\Faker\Provider\BookProvider;
use BDTheque\Faker\Provider\ModelProvider;
use BDTheque\Models\Editeur;
use BDTheque\Models\Genre;
use BDTheque\Models\Personne;
use BDTheque\Models\Serie;
use BDTheque\Models\Univers;
use Faker\Generator as Faker;

/**
 * @var \Illuminate\Database\Eloquent\Factory $factory
 */
$factory->define(Serie::class, function (Faker $faker) {
    $faker->addProvider(new ModelProvider($faker));
    $faker->addProvider(new BookProvider($faker));

    $titreSerie = $faker->unique()->bookTitle($faker->numberBetween(10, 150));
    /** @var Editeur $editeur */
    $editeur = $faker->randomModel(Editeur::class);
    $collection = $editeur->collections()->inRandomOrder()->first();
    return [
        'titre_serie' => $titreSerie,
        'editeur_id' => $editeur->id,
        'collection_id' => $collection ? $collection->id : null,
        'notation' => $faker->optional(10)->numberBetween(0, 10)
    ];
})->afterCreating(Serie::class, function (Serie $serie, Faker $faker) {
    $faker->randomModels($serie->univers(), Univers::class);
    $faker->randomModels($serie->genres(), Genre::class);

    $faker->randomModels($serie->scenaristes(), Personne::class, 75, 1, 3, null, function () {
        return ['metier' => \BDTheque\Models\Metadata\Personne::SCENARISTE];
    });
    $faker->randomModels($serie->dessinateurs(), Personne::class, 75, 1, 3, null, function () {
        return ['metier' => \BDTheque\Models\Metadata\Personne::DESSINATEUR];
    });
    $faker->randomModels($serie->coloristes(), Personne::class, 75, 1, 3, null, function () {
        return ['metier' => \BDTheque\Models\Metadata\Personne::COLORISTE];
    });
});
