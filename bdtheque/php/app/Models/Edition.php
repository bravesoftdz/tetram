<?php

namespace BDTheque\Models;

use Illuminate\Support\Carbon;

/**
 * @property Album $album
 * @property Editeur $editeur
 * @property Collection $collection
 * @property boolean $vo
 * @property boolean $couleur
 * @property integer $etat
 * @property integer $reliure
 * @property integer $type_edition
 * @property integer $orientation
 * @property integer $format_edition
 * @property integer $sens_lecture
 * @property Carbon $date_achat
 * @property integer $annee_edition
 * @property double $prix
 * @property boolean $dedicace
 * @property boolean $gratuit
 * @property boolean $offert
 * @property integer $nombre_de_pages
 * @property string $isbn
 * @property string $numero_perso
 * @property string $notes
 * @property ImageAlbum[] $images
 */
class Edition extends BaseModel
{
    /**
     * The attributes that should be casted to native types.
     *
     * @var array
     */
    protected $casts = [
        'vo' => 'boolean',
        'couleur' => 'boolean',
        'dedicace' => 'boolean',
        'gratuit' => 'boolean',
        'offert' => 'boolean',
        'date_achat' => 'datetime'
    ];

    /**
     * @return \Illuminate\Database\Eloquent\Relations\BelongsTo|Album
     */
    function album()
    {
        return $this->belongsTo(Album::class);
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
     * @return ImageAlbum[]|\Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function images()
    {
        return $this->hasMany(ImageAlbum::class);
    }
}
