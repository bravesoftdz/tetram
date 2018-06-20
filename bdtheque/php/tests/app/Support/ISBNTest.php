<?php

namespace Tests\BDTheque\Support;

use BDTheque\Support\ISBN;
use PHPUnit\Framework\TestCase;

class ISBNTest extends TestCase
{

    public function testFormat()
    {
        $this->assertEquals('978-0-7777-7777-0', ISBN::format('9780777777770'));
        $this->assertEquals('978-952-89-8888-5', ISBN::format('9789528988885'));
        $this->assertEquals('978-2-921548-21-2', ISBN::format('9782921548212'));
        $this->assertEquals('2-921548-21-6', ISBN::format('2921548216'));
    }

    public function testBuild()
    {
        $isbn = ISBN::build();
        fwrite(STDOUT, $isbn.': '.ISBN::format($isbn)."\n");
        $this->assertTrue(true);
    }
}
