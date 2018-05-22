<?php

namespace BDTheque\Models;

class ImageParaBd extends BaseImage implements Metadata\ImageParaBd
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
