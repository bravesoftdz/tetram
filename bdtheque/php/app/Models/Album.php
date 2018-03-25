<?php

namespace BDTheque\Models;

/**
 * @property string $titre_album
 * @property-read string $initiale_titre_album
 * @property integer $mois_parution
 * @property integer $annee_parution
 * @property integer $tome
 * @property integer $tome_debut
 * @property integer $tome_fin
 * @property integer $notation
 * @property boolean $hors_serie
 * @property boolean $integrale
 * @property Univers[] $univers
 * @property string $sujet
 * @property string $notes
 *
 * @property Serie $serie
 *
 * @property Personne[] $scenaristes
 * @property Personne[] $dessinateurs
 * @property Personne[] $coloristes
 *
 * @property Edition[] $editions
 *
 * @property ImageAlbum[] $images
 *
 * @property boolean $prevision_achat
 * @property boolean $valide
 */
class Album extends BaseModel
{
    protected $buildInitialeFrom = 'titre_album';

    protected $casts = [
        'prevision_achat' => 'boolean',
        'valide' => 'boolean',
        'hors_serie' => 'boolean',
        'integrale' => 'boolean'
    ];

    /**
     * @return Serie|\Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function serie()
    {
        return $this->belongsTo(Serie::class);
    }

    /**
     * @return Personne[]|\Illuminate\Database\Eloquent\Relations\BelongsToMany
     */
    public function scenaristes()
    {
        return $this->belongsToMany(Personne::class, 'auteurs_albums')->wherePivot('metier', '=', 0);
    }

    /**
     * @return Personne[]|\Illuminate\Database\Eloquent\Relations\BelongsToMany
     */
    public function dessinateurs()
    {
        return $this->belongsToMany(Personne::class, 'auteurs_albums')->wherePivot('metier', '=', 1);
    }

    /**
     * @return Personne[]|\Illuminate\Database\Eloquent\Relations\BelongsToMany
     */
    public function coloristes()
    {
        return $this->belongsToMany(Personne::class, 'auteurs_albums')->wherePivot('metier', '=', 2);
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\HasMany|Edition[]
     */
    public function editions()
    {
        return $this->hasMany(Edition::class);
    }

    /**
     * @return Univers[]|\Illuminate\Database\Eloquent\Relations\BelongsToMany
     */
    public function univers()
    {
        return $this->belongsToMany(Univers::class, 'univers_albums');
    }

    /**
     * @return ImageAlbum[]|\Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function images()
    {
        return $this->hasMany(ImageAlbum::class);
    }
}
