<?php

namespace BDTheque\Models;

class ImageAlbum extends BaseImage implements Metadata\ImageAlbum
{
    protected $table = 'images_albums';

    /**
     * @return Album|\Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function album()
    {
        return $this->belongsTo(Album::class);
    }

    /**
     * @return Edition|\Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function edition()
    {
        return $this->belongsTo(Edition::class);
    }
}
