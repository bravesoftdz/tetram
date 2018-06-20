<?php

namespace BDTheque\Http\Resources;

use BDTheque\Models\Metadata\Edition;

class EditionResource extends BaseModelResource implements Edition
{
    public $common_properties = [
        'editeur' => [EditeurResource::class, false],
        'collection' => [CollectionResource::class, false]
    ];

    public $full_properties = [
        'vo',
        'couleur',
        'etat',
        'reliure',
        'type_edition',
        'orientation',
        'format_edition',
        'sens_lecture',
        'date_achat',
        'annee_edition',
        'prix',
        'dedicace',
        'gratuit',
        'offert',
        'nombre_de_pages',
        'isbn', 'formatted_isbn',
        'numero_perso',
        'notes',
    ];
}
