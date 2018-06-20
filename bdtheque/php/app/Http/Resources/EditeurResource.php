<?php

namespace BDTheque\Http\Resources;

use BDTheque\Models\Metadata\Edition;

class EditeurResource extends BaseModelResource implements Edition
{
    public $common_properties = [
        'nom_editeur'
    ];
}
