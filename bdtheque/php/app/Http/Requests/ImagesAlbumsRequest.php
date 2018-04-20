<?php

namespace BDTheque\Http\Controllers\Admin;

use BDTheque\Http\Requests\BaseModelRequest;
use BDTheque\Models\ImageAlbum;

class ImagesAlbumsRequest extends BaseModelRequest
{
    protected static $modelClass = ImageAlbum::class;
}