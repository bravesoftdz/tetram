<?php

namespace BDTheque\Http\Resources;

use BDTheque\Models\Metadata\Serie;

class SerieResource extends BaseModelResource implements Serie
{
    public $common_properties = [
        'titre_serie',
        'genres' => [GenreResourceCollection::class, false],
        'editeur' => [EditeurResource::class, false],
        'collection' => [CollectionResource::class, false]
    ];

    public $full_properties = [
        'terminee',
        'complete',
        'suivre_manquants',
        'suivre_sorties',
        'nb_albums',

        'sujet',
        'notes',
        'site_web',

        'vo',
        'couleur',
        'etat',
        'reliure',
        'type_edition',
        'orientation',
        'format_edition',
        'sens_lecture',

        'albums' => [AlbumResourceCollection::class, false],
        'scenaristes' => [PersonneResourceCollection::class, false],
        'dessinateurs' => [PersonneResourceCollection::class, false],
        'coloristes' => [PersonneResourceCollection::class, false],
        'univers' => [UniversResourceCollection::class, false]
    ];

}
