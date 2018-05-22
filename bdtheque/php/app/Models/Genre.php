<?php

namespace BDTheque\Models;

class Genre extends BaseModel implements Metadata\Genre
{
    protected $buildInitialeFrom = 'genre';
    protected static $defaultOrderBy = [
        'genre'
    ];

    protected static $rules = [
        'genre' => 'required|max=30'
    ];
}
