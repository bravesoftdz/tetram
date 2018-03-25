<?php

namespace BDTheque\Models;

/**
 * @property string $nom_personne
 * @property-read string $initiale_nom_personne
 * @property string $biographie
 * @property string $site_web
 */
class Personne extends BaseModel
{
    protected $buildInitialeFrom = 'nom_personne';

    public function albums() {
        $this->belongsToMany(Album::class, 'auteurs_albums');
    }

    public function series() {
        $this->belongsToMany(Serie::class, 'series_albums');
    }
}
