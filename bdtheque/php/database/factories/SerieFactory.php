<?php

use BDTheque\Faker\Provider\BookProvider;
use BDTheque\Faker\Provider\ModelProvider;
use BDTheque\Models\Editeur;
use BDTheque\Models\Personne;
use BDTheque\Models\Serie;
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
        'collection_id' => $collection ? $collection->id : null
    ];
})->afterCreating(Serie::class, function (Serie $serie, Faker $faker) {
    $s = $faker->boolean(75) ? $faker->numberBetween(1, 3) : 0;
    $d = $faker->boolean(75) ? $faker->numberBetween(1, 3) : 0;
    $c = $faker->boolean(75) ? $faker->numberBetween(1, 3) : 0;

    $auteurs = [];
    while ($s-- > 0) $auteurs += [$faker->randomModel(Personne::class)->id => ['metier' => \BDTheque\Models\Metadata\Personne::SCENARISTE]];
    $serie->scenaristes()->sync($auteurs);

    $auteurs = [];
    while ($d-- > 0) $auteurs += [$faker->randomModel(Personne::class)->id => ['metier' => \BDTheque\Models\Metadata\Personne::DESSINATEUR]];
    $serie->dessinateurs()->sync($auteurs);

    $auteurs = [];
    while ($c-- > 0) $auteurs += [$faker->randomModel(Personne::class)->id => ['metier' => \BDTheque\Models\Metadata\Personne::COLORISTE]];
    $serie->coloristes()->sync($auteurs);
});
