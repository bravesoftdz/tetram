<?php

namespace BDTheque\Models\Metadata;

use Illuminate\Support\Carbon;

/**
 * @property string $titre_para_bd
 * @property-read string $initiale_titre_para_bd
 * @property Serie $serie
 * @property Personne[] $scenaristes
 * @property Personne[] $dessinateurs
 * @property Personne[] $coloristes
 * @property integer $categorie_para_bd
 * @property string $description
 * @property string $notes
 *
 * @property Carbon $date_achat
 * @property boolean $prevision_achat
 * @property boolean $valide
 * @property integer $annee
 * @property double $prix
 * @property boolean $dedicace
 * @property boolean $numerote
 * @property boolean $gratuit
 * @property boolean $offert
 * @property Univers[] $univers
 * @property ImageParaBd[] $images
 */
interface ParaBd extends Base
{

}