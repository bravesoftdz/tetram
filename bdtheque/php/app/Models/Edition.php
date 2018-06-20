<?php

namespace BDTheque\Models;

use BDTheque\Support\ISBN;

class Edition extends BaseModel implements Metadata\Edition
{
    protected $casts = [
        'vo' => 'boolean',
        'couleur' => 'boolean',
        'dedicace' => 'boolean',
        'gratuit' => 'boolean',
        'offert' => 'boolean',
        'date_achat' => 'datetime'
    ];

    protected $with = [
        'editeur',
        'collection'
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

    public function getFormattedIsbnAttribute()
    {
        return ISBN::format($this->isbn);
    }
}
