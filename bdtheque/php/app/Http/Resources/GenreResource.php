<?php

namespace BDTheque\Http\Resources;

use BDTheque\Models\Metadata\Genre;

class GenreResource extends BaseModelResource implements Genre
{
    public $common_properties = [
      'genre'
    ];
}
