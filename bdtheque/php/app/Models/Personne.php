<?php

namespace BDTheque\Models;

class Personne extends BaseModel implements Metadata\Personne
{
    protected $buildInitialeFrom = 'nom_personne';
    protected static $defaultOrderBy = [
        'nom_personne'
    ];

    public function albums()
    {
        $this->belongsToMany(Album::class, 'auteurs_albums');
    }

    public function series()
    {
        $this->belongsToMany(Serie::class, 'series_albums');
    }
}
