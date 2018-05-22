<?php

namespace BDTheque\Http\Resources;

use BDTheque\Models\Metadata\Album;

class AlbumResource extends BaseModelResource implements Album
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
            parent::toArray($request) +
            [
                'titre_album' => $this->when(isset($this->titre_album), $this->titre_album),
                'mois_parution' => $this->when(isset($this->mois_parution), $this->mois_parution),
                'annee_parution' => $this->when(isset($this->annee_parution), $this->annee_parution),
                'tome' => $this->when(isset($this->tome), $this->tome),
                'tome_debut' => $this->when(isset($this->tome_debut), $this->tome_debut),
                'tome_fin' => $this->when(isset($this->tome_fin), $this->tome_fin),
                'hors_serie' => $this->when(isset($this->hors_serie), $this->hors_serie),
                'integrale' => $this->when(isset($this->integrale), $this->integrale),
                'notation' => $this->when(isset($this->notation), $this->notation),
                'serie' => $this->when(isset($this->serie_id), function () {
                    return new SerieResource($this->serie, false);
                })
            ];
    }
}
