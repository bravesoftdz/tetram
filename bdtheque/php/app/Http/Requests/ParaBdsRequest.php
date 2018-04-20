<?php

namespace BDTheque\Http\Controllers\Admin;

use BDTheque\Http\Requests\BaseModelRequest;
use BDTheque\Models\ParaBd;

class ParaBdsRequest extends BaseModelRequest
{
    protected static $modelClass = ParaBd::class;
}