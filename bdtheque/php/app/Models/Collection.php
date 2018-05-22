<?php

namespace BDTheque\Models;

class Collection extends BaseModel implements Metadata\Collection
{
    protected $buildInitialeFrom = 'nom_collection';
    protected static $defaultOrderBy = [
        'nom_collection'
    ];

    /**
     * @return Editeur|\Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function editeur()
    {
        return $this->belongsTo(Editeur::class);
    }


}
