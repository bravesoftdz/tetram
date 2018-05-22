<?php

namespace BDTheque\Http\Resources;

use BDTheque\Models\Metadata\Serie;

class SerieResource extends BaseModelResource implements Serie
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
                'titre_serie' => $this->when(isset($this->titre_serie), $this->titre_serie)
            ];
    }
}
