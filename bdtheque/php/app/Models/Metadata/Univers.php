<?php

namespace BDTheque\Models\Metadata;

/**
 * @property string $nom_univers
 * @property-read string $initiale_nom_univers
 * @property string $description
 * @property string $site_web
 * @property Univers $univers_parent
 * @property Univers $univers_racine
 * @property string $univers_branches
 */
interface Univers extends Base
{

}