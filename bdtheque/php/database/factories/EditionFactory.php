<?php

use BDTheque\Faker\Provider\BookProvider;
use BDTheque\Faker\Provider\ModelProvider;
use BDTheque\Models\Collection;
use BDTheque\Models\Editeur;
use BDTheque\Models\Edition;
use BDTheque\Support\ExtendedEloquentBuilder;
use Faker\Generator as Faker;

/**
 * @var \Illuminate\Database\Eloquent\Factory $factory
 */
$factory->define(Edition::class, function (Faker $faker) {
    $faker->addProvider(new ModelProvider($faker));
    $faker->addProvider(new BookProvider($faker));

    $editeur = $faker->randomModel(Editeur::class);
    $collection = $editeur
        ? $faker->optional(50)->randomModel(Collection::class, function (ExtendedEloquentBuilder $query) use ($editeur) {
            $query->where('editeur_id', $editeur->id);
        })
        : null;
    $gratuit = $faker->boolean(25);

    $date_achat = $faker->dateTimeThisDecade();
    return [
//    * @property Album $album
        'editeur_id' => $editeur->id,
        'collection_id' => $collection ? $collection->id : null,
        'vo' => $faker->boolean(1),
        'couleur' => $faker->boolean(99),
        'etat' => $faker->optional(75)->randomEnum('etat'),
        'reliure' => $faker->optional(75)->randomEnum('reliure'),
        'type_edition' => $faker->optional(75)->randomEnum('type_edition'),
        'orientation' => $faker->optional(75)->randomEnum('orientation'),
        'format_edition' => $faker->optional(75)->randomEnum('format_edition'),
        'sens_lecture' => $faker->optional(75)->randomEnum('sens_lecture'),
        'date_achat' => $date_achat,
        'annee_edition' => $faker->optional()->year($date_achat),
        'prix' => $gratuit ? null : $faker->optional(90)->randomFloat(2, 8, 25),
        'dedicace' => $faker->optional(75)->boolean(10),
        'gratuit' => $gratuit,
        'offert' => $faker->boolean(25),
        'nombre_de_pages' => $faker->optional(10)->numberBetween(25, 90),
        'isbn' => $faker->ISBN(),
//    * @property string $numero_perso
//    * @property string $notes
//    * @property ImageAlbum[] $images
    ];
})->afterCreating(Edition::class, function (Edition $edition, Faker $faker) {

});
