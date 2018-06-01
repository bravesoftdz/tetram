<?php

namespace BDTheque\Models;

class Album extends BaseModel implements Metadata\Album
{
    protected $buildInitialeFrom = 'titre_album';
    protected $casts = [
        'prevision_achat' => 'boolean',
        'valide' => 'boolean',
        'hors_serie' => 'boolean',
        'integrale' => 'boolean'
    ];

    protected static $defaultOrderBy = [
        'coalesce(albums.titre_album, series.titre_serie)', 'serie.titre_serie',
        'hors_serie', 'integrale',
        'tome', 'tome_debut', 'tome_fin',
        'annee_parution', 'mois_parution'
    ];

    protected static $orderBy = [
        'subindex' => [
            'hors_serie', 'integrale',
            'tome', 'tome_debut', 'tome_fin',
            'annee_parution', 'mois_parution'
        ]
    ];

    protected $with = [
        'serie'
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
