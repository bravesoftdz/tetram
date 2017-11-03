<?php

namespace BDTheque\DataModelBundle\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * BDTheque\DataModelBundle\Entity\ScenaristeSerie
 * 
 * @ORM\Entity
 */
class ScenaristeSerie extends AuteurSerie {

    public function setSerie(Serie $serie) {
        $serie->addScenariste($this);
        return parent::setSerie($serie);
    }

}

?>