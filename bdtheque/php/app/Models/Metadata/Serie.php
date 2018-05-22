<?php

namespace BDTheque\Models\Metadata;

/**
 * @property string $titre_serie
 * @property-read string $initiale_titre_serie
 * @property Editeur $editeur
 * @property Collection $collection
 *
 * @property boolean $terminee
 * @property boolean $complete
 * @property boolean $suivre_manquants
 * @property boolean $suivre_sorties
 * @property integer $nb_albums
 *
 * @property string $sujet
 * @property string $notes
 * @property string $site_web
 *
 * @property boolean $vo
 * @property boolean $couleur
 * @property integer $etat
 * @property integer $reliure
 * @property integer $type_edition
 * @property integer $orientation
 * @property integer $format_edition
 * @property integer $sens_lecture
 * @property integer $notation
 *
 * @property Album[] $albums
 * @property Personne[] $scenaristes
 * @property Personne[] $dessinateurs
 * @property Personne[] $coloristes
 * @property Univers[] $univers
 * @property Genre[] $genres
 */
interface Serie extends Base
{
    
}