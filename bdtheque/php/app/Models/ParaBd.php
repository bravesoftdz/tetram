<?php

namespace BDTheque\Models;

use Illuminate\Database\Eloquent\Builder;
use Illuminate\Support\Carbon;


/**
 * @property string $titre_para_bd
 * @property-read string $initiale_titre_para_bd
 * @property Serie $serie
 * @property Personne[] $scenaristes
 * @property Personne[] $dessinateurs
 * @property Personne[] $coloristes
 * @property integer $categorie_para_bd
 * @property string $description
 * @property string $notes
 *
 * @property Carbon $date_achat
 * @property boolean $prevision_achat
 * @property boolean $valide
 * @property integer $annee
 * @property double $prix
 * @property boolean $dedicace
 * @property boolean $numerote
 * @property boolean $gratuit
 * @property boolean $offert
 * @property Univers[] $univers
 * @property ImageParaBd[] $images
 */
class ParaBd extends BaseModel
{
    protected $buildInitialeFrom = 'titre_para_bd';

    /**
     * The attributes that should be casted to native types.
     *
     * @var array
     */
    protected $casts = [
        'prevision_achat' => 'boolean',
        'valide' => 'boolean',
        'dedicace' => 'boolean',
        'numerote' => 'boolean',
        'gratuit' => 'boolean',
        'offert' => 'boolean',
        'date_achat' => 'datetime'
    ];

    /**
     * Scope pour n'avoir que les parabd valide (= exclu les fantomes présents juste pour les prévisions d'achat).
     *
     * @param \Illuminate\Database\Eloquent\Builder $query
     * @return \Illuminate\Database\Eloquent\Builder
     */
    public function scopeValides(Builder $query): Builder
    {
        return $query->where('valide', '=', true);
    }

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
        return $this->belongsToMany(Personne::class, 'auteurs_para_bds')->wherePivot('metier', '=', 0);
    }

    /**
     * @return Personne[]|\Illuminate\Database\Eloquent\Relations\BelongsToMany
     */
    public function dessinateurs()
    {
        return $this->belongsToMany(Personne::class, 'auteurs_para_bds')->wherePivot('metier', '=', 1);
    }

    /**
     * @return Personne[]|\Illuminate\Database\Eloquent\Relations\BelongsToMany
     */
    public function coloristes()
    {
        return $this->belongsToMany(Personne::class, 'auteurs_para_bds')->wherePivot('metier', '=', 2);
    }

    /**
     * @return Univers[]|\Illuminate\Database\Eloquent\Relations\BelongsToMany
     */
    public function univers()
    {
        return $this->belongsToMany(Univers::class, 'univers_para_bds');
    }

    /**
     * @return ImageParaBd[]|\Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function images()
    {
        return $this->hasMany(ImageParaBd::class);
    }
}
