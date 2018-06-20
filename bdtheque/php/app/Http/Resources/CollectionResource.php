<?php

namespace BDTheque\Http\Resources;

use BDTheque\Models\Metadata\Edition;

class CollectionResource extends BaseModelResource implements Edition
{
    public $common_properties = [
        'nom_collection'
    ];
}
