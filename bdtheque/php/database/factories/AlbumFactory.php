<?php

use BDTheque\Faker\Provider\BookProvider;
use BDTheque\Faker\Provider\ModelProvider;
use BDTheque\Models\Album;
use BDTheque\Models\Edition;
use BDTheque\Models\Personne;
use BDTheque\Models\Serie;
use BDTheque\Models\Univers;
use Faker\Generator as Faker;

/**
 * @var \Illuminate\Database\Eloquent\Factory $factory
 */
$factory->define(Album::class, function (Faker $faker) {
    $faker->addProvider(new ModelProvider($faker));
    $faker->addProvider(new BookProvider($faker));

    $titreAlbum = optional($faker->optional()->unique())->bookTitle($faker->numberBetween(10, 150));
    $tome = $faker->optional()->randomDigitNotNull;
    $tomeDebut = $tome ? null : $faker->optional()->randomDigitNotNull;
    $tomeFin = $tomeDebut ? $faker->numberBetween($tomeDebut + 1, 25) : null;
    $anneeParution = $faker->optional()->numberBetween(1970, 2018);
    $serie = $faker->optional($titreAlbum ? 50 : 100)->randomModel(Serie::class);

    return [
        'titre_album' => $titreAlbum,
        'tome' => $tome,
        'tome_debut' => $tomeDebut,
        'tome_fin' => $tomeFin,
        'annee_parution' => $anneeParution,
        'mois_parution' => $anneeParution ? $faker->optional()->numberBetween(1, 12) : null,
        'serie_id' => $serie ? $serie->id : null,
        'hors_serie' => $serie ? $faker->boolean(10) : false,
        'integrale' => $tomeDebut ? true : false,
        'notation' => $faker->optional(10)->numberBetween(0, 10)
    ];
})->afterCreating(Album::class, function (Album $album, Faker $faker) {
    $faker->randomModels($album->univers(), Univers::class);

    $faker->randomModels($album->scenaristes(), Personne::class, 75, 1, 3, null, function () {
        return ['metier' => \BDTheque\Models\Metadata\Personne::SCENARISTE];
    });
    $faker->randomModels($album->dessinateurs(), Personne::class, 75, 1, 3, null, function () {
        return ['metier' => \BDTheque\Models\Metadata\Personne::DESSINATEUR];
    });
    $faker->randomModels($album->coloristes(), Personne::class, 75, 1, 3, null, function () {
        return ['metier' => \BDTheque\Models\Metadata\Personne::COLORISTE];
    });

    $e = $faker->boolean(95) ? 1 : $faker->numberBetween(0, 3);
    $album->editions()->saveMany(factory(Edition::class, $e)->make());
});

