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
                $model->buildInitialeFrom = trim($model->buildInitialeFrom);

                $initiale_var = 'initiale_' . $model->buildInitialeFrom;
                if (!$model->buildInitialeFrom)
                    $model->$initiale_var = null;
                elseif (empty($model->buildInitialeFrom))
                    $model->$initiale_var = '#';
                else {
                    $model->$initiale_var = ucfirst($model->buildInitialeFrom)[0];
                    if (!(ctype_alpha($model->$initiale_var)))
                        $model->$initiale_var = '#';
                }
            }

            return true;
        });
    }

}
