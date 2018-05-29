<?php

namespace BDTheque\Models;

class Serie extends BaseModel implements Metadata\Serie
{
    protected $buildInitialeFrom = 'titre_serie';
    protected $casts = [
        'terminee' => 'boolean',
        'complete' => 'boolean',
        'suivre_manquants' => 'boolean',
        'suivre_sorties' => 'boolean',
        'vo' => 'boolean',
        'couleur' => 'boolean',
    ];

    protected static $defaultOrderBy = [
        'titre_serie',
        'editeur.nom_editeur',
        'collection.nom_collection'
    ];
    protected $with = [
        'editeur', 'collection'
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
