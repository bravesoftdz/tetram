<?php

namespace BDTheque\Faker\Provider;

use Faker\Provider\Base;

class BookProvider extends Base
{
    /**
     * @param $maxNbChars
     * @return string
     */
    public function bookTitle($maxNbChars = 150)
    {
        $title = $this->generator->text($this->generator->numberBetween(10, $maxNbChars));
        if ($this->generator->boolean(25))
            $title .= ' [' . $this->generator->randomElement(['XX', 'Z\'']) . ']';

        return $title;
    }

    public function ISBN()
    {
        return $this->generator->ean13();
    }

}