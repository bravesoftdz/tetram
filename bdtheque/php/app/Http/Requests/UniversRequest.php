<?php

namespace BDTheque\Http\Requests;

use BDTheque\Models\Univers;

class UniversRequest extends BaseModelRequest
{
    protected static $modelClass = Univers::class;
}
