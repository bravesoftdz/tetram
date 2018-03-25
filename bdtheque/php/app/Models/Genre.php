<?php

namespace BDTheque\Models;

/**
 * @property string $genre
 * @property-read string $initiale_genre
 */
class Genre extends BaseModel
{
    protected $buildInitialeFrom = 'genre';
}
