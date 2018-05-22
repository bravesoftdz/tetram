<?php

namespace BDTheque\Models;

class Edition extends BaseModel implements Metadata\Edition
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
