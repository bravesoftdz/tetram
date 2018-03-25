<?php
/**
 * Created by PhpStorm.
 * User: Thierry
 * Date: 26/03/2018
 * Time: 14:00
 */

namespace BDTheque\Support;

use Illuminate\Support\Str;

/**
 * Class Enum
 * @package BDTheque\Support
 */
abstract class Enum
{
    /**
     * @return string
     */
    private static function getTranslateTag(): string
    {
        $tag = explode('\\', get_called_class());
        return 'enum.' . Str::snake(end($tag));
    }

    /**
     * @return string
     */
    private static function getDefaultValueTag(): string
    {
        return self::getTranslateTag() . '.default';
    }

    /**
     * @return string
     */
    private static function getValuesTag(): string
    {
        return self::getTranslateTag() . '.values';
    }

    /**
     * @param int $value
     * @return string
     */
    private static function getLabelTag(integer $value): string
    {
        return self::getTranslateTag() . '.' . $value;
    }

    /**
     * @return \Illuminate\Config\Repository|mixed
     */
    public static function getKeys()
    {
        return config(self::getValuesTag());
    }

    /**
     * @return \Illuminate\Config\Repository|mixed
     */
    public static function getDefaultValue()
    {
        return config(self::getDefaultValueTag());
    }

    /**
     * @param int $value
     * @return string
     */
    public static function getLibelle(integer $value): string
    {
        return trans(self::getLabelTag($value));
    }
}