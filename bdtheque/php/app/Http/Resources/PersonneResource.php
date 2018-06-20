<?php

namespace BDTheque\Http\Resources;

use BDTheque\Models\Metadata\Personne;

class PersonneResource extends BaseModelResource implements Personne
{
    public $common_properties = [
        'nom_personne'
    ];

    public $full_properties = [
        'albums' => [AlbumResourceCollection::class, false]
    ];
}
