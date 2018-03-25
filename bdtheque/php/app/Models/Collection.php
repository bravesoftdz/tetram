<?php

namespace BDTheque\Models;

/**
 * @property string $nom_collection
 * @property-read string $initiale_nom_collection
 * @property Editeur $editeur
 */
class Collection extends BaseModel
{
    protected $buildInitialeFrom = 'nom_collection';

    /**
     * @return Editeur|\Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function editeur()
    {
        return $this->belongsTo(Editeur::class);
    }


}
