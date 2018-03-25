<?php
/**
 * Created by PhpStorm.
 * User: Thierry
 * Date: 26/03/2018
 * Time: 14:17
 */

namespace Tests\BDTheque\Support;

use BDTheque\Support\CategorieImageAlbum;
use BDTheque\Support\CategorieImageParaBd;
use BDTheque\Support\Enum;
use BDTheque\Support\Etat;
use BDTheque\Support\FormatEdition;
use BDTheque\Support\Notation;
use BDTheque\Support\Orientation;
use BDTheque\Support\Reliure;
use BDTheque\Support\SensLecture;
use BDTheque\Support\TypeEdition;
use BDTheque\Support\TypeParaBd;
use PHPUnit\Framework\TestCase;
use Tests\CreatesApplication;

class EnumTest extends TestCase
{
    use CreatesApplication;

    protected function setUp()/* The :void return type declaration that should be here would cause a BC issue */
    {
        parent::setUp();
        $this->createApplication();
        config()->set('enum.enum', ['values' => [110, 120, 130], 'default' => 110]);
    }

    /**
     * @return array
     */
    public function classListProvider()
    {
        return [
            'CategorieImageAlbum' => [CategorieImageAlbum::class],
            'CategorieImageParaBd' => [CategorieImageParaBd::class],
            'Etat' => [Etat::class],
            'FormatEdition' => [FormatEdition::class],
            'Notation' => [Notation::class],
            'Orientation' => [Orientation::class],
            'Reliure' => [Reliure::class],
            'SensLecture' => [SensLecture::class],
            'TypeEdition' => [TypeEdition::class],
            'TypeParaBd' => [TypeParaBd::class],
        ];
    }

    /**
     * @dataProvider classListProvider
     * @param $class
     */
    public function testGetKeys($class)
    {
        $keys = $class::getKeys();

        $this->assertFalse(empty($keys), '$keys must not be empty');
        $this->assertTrue(is_array($keys), '$keys must be an array');
    }

    /**
     * @dataProvider classListProvider
     * @param $class
     */
    public function testDefaultValue($class)
    {
        $default_value = $class::getDefaultValue();
        $keys = $class::getKeys();

        $this->assertTrue(empty($default_value) || in_array($default_value, $keys), 'default value not included in keys');
    }
}
