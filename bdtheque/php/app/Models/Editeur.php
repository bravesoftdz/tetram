<?php

namespace BDTheque\Models;

/**
 * @property string $nom_editeur
 * @property-read string $initiale_nom_editeur
 * @property string $site_web
 * @property Collection[] $collections
 */
class Editeur extends BaseModel
{
    protected $buildInitialeFrom = 'nom_editeur';

    /**
     * @return Collection[]|\Illuminate\Database\Eloquent\Relations\HasMany
     */
    function collections() {
        return $this->hasMany(Collection::class);
    }
}
