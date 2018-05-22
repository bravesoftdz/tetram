<?php

namespace BDTheque\Faker\Provider;

use Faker\Provider\Base;

class AuthorProvider extends Base
{
    public function authorName(): string
    {
        $name = $this->generator->lastName;
        if ($this->generator->boolean(75))
            $name .= ' [' . $this->generator->firstName . ']';
        return $name;
    }
}