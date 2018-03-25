<?php

namespace BDTheque\Models;

/**
 * Class ImageParaBd
 * @package BDTheque\Models
 *
 * @property ParaBd $para_bd
 */
class ImageParaBd extends BaseImage
{
    protected $table = 'images_para_bds';

    /**
     * @return ParaBd|\Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function para_bd()
    {
        return $this->belongsTo(ParaBd::class);
    }
}
