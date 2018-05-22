<?php

namespace BDTheque\Http\Resources;

use BDTheque\Models\Metadata\Personne;

class PersonneResource extends BaseModelResource implements Personne
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
                'nom_personne' => $this->when(isset($this->nom_personne), $this->nom_personne)
            ];
    }
}
