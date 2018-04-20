<?php

namespace BDTheque\Http\Controllers\Admin;

use BDTheque\Http\Requests\BaseModelRequest;
use BDTheque\Models\ImageParaBd;

class ImagesParaBdsRequest extends BaseModelRequest
{
    protected static $modelClass = ImageParaBd::class;
}