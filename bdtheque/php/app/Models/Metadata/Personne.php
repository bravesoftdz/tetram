<?php

namespace BDTheque\Models\Metadata;

/**
 * @property string $nom_personne
 * @property-read string $initiale_nom_personne
 * @property string $biographie
 * @property string $site_web
 */
interface Personne extends Base
{
    const SCENARISTE = 0;
    const DESSINATEUR = 1;
    const COLORISTE = 2;
}