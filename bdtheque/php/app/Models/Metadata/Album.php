<?php

namespace BDTheque\Models\Metadata;

/**
 * @property string $titre_album
 * @property-read string $initiale_titre_album
 * @property integer $mois_parution
 * @property integer $annee_parution
 * @property integer $tome
 * @property integer $tome_debut
 * @property integer $tome_fin
 * @property integer $notation
 * @property boolean $hors_serie
 * @property boolean $integrale
 * @property Univers[] $univers
 * @property string $sujet
 * @property string $notes
 *
 * @property Serie $serie
 *
 * @property Personne[] $scenaristes
 * @property Personne[] $dessinateurs
 * @property Personne[] $coloristes
 *
 * @property Edition[] $editions
 *
 * @property ImageAlbum[] $images
 *
 * @property boolean $prevision_achat
 * @property boolean $valide
 */
interface Album extends Base
{
    
}