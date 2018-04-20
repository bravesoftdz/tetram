<?php

namespace BDTheque\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Str;

/**
 * @property string $id
 * @property \Carbon\Carbon $created_at
 * @property \Carbon\Carbon $updated_at
 * @property \Carbon\Carbon $deleted_at
 */
abstract class BaseModel extends Model
{
    use SoftDeletes;

    public $incrementing = false;
    protected $keyType = 'string';
    protected $dates = [Model::CREATED_AT, Model::UPDATED_AT, 'deleted_at'];

    protected static $rules = [];

    /**
     * Field name from which make an "initiale_$buildInitiale" field
     * @var string
     */
    protected $buildInitialeFrom = null;

    /**
     * The booting method of the model.
     *
     * @return void
     */
    public static function boot()
    {
        parent::boot();

        static::creating(function (BaseModel $model): bool {
            $model->{$model->getKeyName()} = Str::uuid()->toString();

            return true;
        });

        static::saving(function (BaseModel $model): bool {
            $keyName = $model->getKeyName();
            $original_id = $model->getOriginal($keyName);
            if ($original_id !== $model->$keyName)
                $model->$keyName = $original_id;

            if ($model->buildInitialeFrom) {
                $initiale_from_var = trim($model->buildInitialeFrom);
                $initiale_var = 'initiale_' . $initiale_from_var;

                if (!$model->$initiale_from_var)
                    $model->$initiale_var = null;
                elseif (empty($model->$initiale_from_var))
                    $model->$initiale_var = '#';
                else {
                    $model->$initiale_var = ucfirst($model->$initiale_from_var)[0];
                    if (!(ctype_alpha($model->$initiale_var)))
                        $model->$initiale_var = '#';
                }
            }

            return true;
        });
    }

    /**
     * Returns model's global validation rules
     *
     * @return array
     */
    protected static function getRules(): array
    {
        return self::$rules;
    }

    /**
     * Returns model's creation validation rules
     *
     * @return array
     */
    public static function getCreateRules(): array
    {
        return self::getRules();
    }

    /**
     * Returns model's update validation rules
     *
     * @return array
     */
    public static function getUpdateRules(): array
    {
        return self::getRules();
    }

}
