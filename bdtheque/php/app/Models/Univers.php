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

        static::saving(function (Univers $univers): ?bool {
            $univers->checkId();

            $univers_parent = $univers->univers_parent;

            $univers_racine = $univers_parent ? ($univers_parent->univers_racine ?: $univers_parent) : null;

            $univers->univers_racine()->associate($univers_racine);

            $univers->updateBranche();

            // return null to allow other events to be fired
            return null;
        });

        static::saved(function (Univers $univers): ?bool {
            if ($univers->univers_branches === $univers->getOriginal('univers_branches'))
                return null;

            Univers::query()
                ->where('univers_branches', '=', $univers->id)
                ->each(function (Univers $univers): bool {
                    $univers->updateBranche()->save();
                    return true;
                });

            // return null to allow other events to be fired
            return null;
        });

    }

    /**
     * @return $this
     */
    protected function updateBranche()
    {
        $this->univers_branches = ($this->univers_parent ? $this->univers_parent->univers_branches : '|') . $this->id . '|';
        return $this;
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
