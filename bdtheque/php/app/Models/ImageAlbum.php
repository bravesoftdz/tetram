<?php

namespace BDTheque\Models;

/**
 * Class ImageAlbum
 * @package BDTheque\Models
 *
 * @property Album $album
 * @property Edition $edition
 */
class ImageAlbum extends BaseImage
{
    protected $table = 'albums_albums';

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
