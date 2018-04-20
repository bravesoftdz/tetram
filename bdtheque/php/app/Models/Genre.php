<?php

namespace BDTheque\Models;

/**
 * @property string $genre
 * @property-read string $initiale_genre
 */
class Genre extends BaseModel
{
    protected $buildInitialeFrom = 'genre';

    protected static $rules = [
      'genre' => 'required|max=30'
    ];
}
