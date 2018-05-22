<?php

namespace BDTheque\Models\Metadata;

use Illuminate\Support\Carbon;

/**
 * @property Album $album
 * @property Editeur $editeur
 * @property Collection $collection
 * @property boolean $vo
 * @property boolean $couleur
 * @property integer $etat
 * @property integer $reliure
 * @property integer $type_edition
 * @property integer $orientation
 * @property integer $format_edition
 * @property integer $sens_lecture
 * @property Carbon $date_achat
 * @property integer $annee_edition
 * @property double $prix
 * @property boolean $dedicace
 * @property boolean $gratuit
 * @property boolean $offert
 * @property integer $nombre_de_pages
 * @property string $isbn
 * @property string $numero_perso
 * @property string $notes
 * @property ImageAlbum[] $images
 */
interface Edition extends Base
{

}