<?php

namespace BDTheque\Models;

/**
 * @property string $titre_serie
 * @property-read string $initiale_titre_serie
 * @property Editeur $editeur
 * @property Collection $collection
 *
 * @property boolean $terminee
 * @property boolean $complete
 * @property boolean $suivre_manquants
 * @property boolean $suivre_sorties
 * @property integer $nb_albums
 *
 * @property string $sujet
 * @property string $notes
 * @property string $site_web
 *
 * @property boolean $vo
 * @property boolean $couleur
 * @property integer $etat
 * @property integer $reliure
 * @property integer $type_edition
 * @property integer $orientation
 * @property integer $format_edition
 * @property integer $sens_lecture
 * @property integer $notation
 *
 * @property Album[] $albums
 * @property Personne[] $scenaristes
 * @property Personne[] $dessinateurs
 * @property Personne[] $coloristes
 * @property Univers[] $univers
 * @property Genre[] $genres
 */
class Serie extends BaseModel
{
    protected $buildInitialeFrom = 'titre_serie';

    /**
     * The attributes that should be casted to native types.
     *
     * @var array
     */
    protected $casts = [
        'terminee' => 'boolean',
        'complete' => 'boolean',
        'suivre_manquants' => 'boolean',
        'suivre_sorties' => 'boolean',
        'vo' => 'boolean',
        'couleur' => 'boolean',
    ];

    /**
     * @return Genre[]|\Illuminate\Database\Eloquent\Relations\BelongsToMany
     */
    public function genres()
    {
        return $this->belongsToMany(Genre::class, 'genres_series');
    }

    /**
     * @return Editeur|\Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function editeur()
    {
        return $this->belongsTo(Editeur::class);
    }

    /**
     * @return Collection|\Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function collection()
    {
        return $this->belongsTo(Collection::class);
    }

    /**
     * @return Album[]|\Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function albums()
    {
        return $this->hasMany(Album::class);
    }

    /**
     * @return Personne[]|\Illuminate\Database\Eloquent\Relations\BelongsToMany
     */
    public function scenaristes()
    {
        return $this->belongsToMany(Personne::class, 'auteurs_series')->wherePivot('metier', '=', 0);
    }

    /**
     * @return Personne[]|\Illuminate\Database\Eloquent\Relations\BelongsToMany
     */
    public function dessinateurs()
    {
        return $this->belongsToMany(Personne::class, 'auteurs_series')->wherePivot('metier', '=', 1);
    }

    /**
     * @return Personne[]|\Illuminate\Database\Eloquent\Relations\BelongsToMany
     */
    public function coloristes()
    {
        return $this->belongsToMany(Personne::class, 'auteurs_series')->wherePivot('metier', '=', 2);
    }

    /**
     * @return Univers[]|\Illuminate\Database\Eloquent\Relations\BelongsToMany
     */
    public function univers()
    {
        return $this->belongsToMany(Univers::class, 'univers_series');
    }
}
