<?php

namespace BDTheque\Http\Resources;

use BDTheque\Models\Metadata\Univers;

class UniversResource extends BaseModelResource implements Univers
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request $request
     * @return array
     */
    public function toArray($request)
    {
        return
            parent::toArray($request) + [
                'nom_univers' => $this->when(isset($this->nom_univers), $this->nom_univers)
            ];
    }
}
