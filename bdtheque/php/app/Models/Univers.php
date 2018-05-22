<?php

namespace BDTheque\Models;

class Univers extends BaseModel implements Metadata\Univers
{
    protected $buildInitialeFrom = 'nom_univers';
    protected static $defaultOrderBy = [
        'nom_univers'
    ];

    public static function boot()
    {
        parent::boot();

        static::saving(function (Univers $univers): bool {
            if ($univers->univers_parent && $univers->univers_racine !== $univers->univers_parent->univers_racine)
                $univers->univers_racine = $univers->univers_parent->univers_racine;
            if (!$univers->univers_parent && $univers->univers_racine)
                $univers->univers_parent = $univers->univers_racine;

            $univers->univers_branches = null;
            if ($univers->univers_parent && $univers->univers_racine)
                $univers->univers_branches = $univers->univers_parent->univers_branches . "|" . $univers->univers_parent->id;

            return true;
        });

    }

    /**
     * @return Univers|\Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function univers_parent()
    {
        return $this->belongsTo(Univers::class, 'parent_univers_id');
    }

    /**
     * @return Univers|\Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function univers_racine()
    {
        return $this->belongsTo(Univers::class, 'racine_univers_id');
    }

}
