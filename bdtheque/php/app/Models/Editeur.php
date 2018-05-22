<?php

namespace BDTheque\Models;

class Editeur extends BaseModel implements Metadata\Editeur
{
    protected $buildInitialeFrom = 'nom_editeur';
    protected static $defaultOrderBy = [
        'nom_editeur'
    ];

    /**
     * @return Collection[]|\Illuminate\Database\Eloquent\Relations\HasMany
     */
    function collections()
    {
        return $this->hasMany(Collection::class);
    }
}
