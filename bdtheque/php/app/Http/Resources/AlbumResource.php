<?php

namespace BDTheque\Http\Resources;

use BDTheque\Models\Metadata\Album;

class AlbumResource extends BaseModelResource implements Album
{
    public $common_properties = [
        'titre_album',
        'mois_parution',
        'annee_parution',
        'tome',
        'tome_debut',
        'tome_fin',
        'hors_serie',
        'integrale',
        'serie' => [SerieResource::class, false],
        'prevision_achat',
        'valide',
    ];

    public $full_properties =  [
        'sujet',
        'notes',
        'univers' => [UniversResourceCollection::class, false],
        'scenaristes' => [PersonneResourceCollection::class, false],
        'dessinateurs' => [PersonneResourceCollection::class, false],
        'coloristes' => [PersonneResourceCollection::class, false],
        'editions' => [EditionResourceCollection::class, true],
        'images' => [ImageAlbumResourceCollection::class, false]
    ];
}
