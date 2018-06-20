<?php

namespace BDTheque\Models;

class Personne extends BaseModel implements Metadata\Personne
{
    protected $buildInitialeFrom = 'nom_personne';
    protected static $defaultOrderBy = [
        'nom_personne'
    ];

    protected $withFull = [
        'albums'
    ];

    public function albums()
    {
        return $this->belongsToMany(Album::class, 'auteurs_albums')->distinct();
    }

    public function series()
    {
        return $this->belongsToMany(Serie::class, 'auteurs_albums')->distinct();
    }
}
