<?php

namespace BDTheque\Http\Resources;

use BDTheque\Models\Metadata\Univers;

class UniversResource extends BaseModelResource implements Univers
{
    public $common_properties = [
        'nom_univers'
    ];

    public $full_properties = [
        'univers_parent' => [UniversResource::class, false, 'parent_univers_id'],
        'univers_racine' => [UniversResource::class, false, 'racine_univers_id'],
        'univers_branches',
        'description',
        'site_web',
        'albums' => [BaseModelResourceCollection::class, false]
    ];
}
