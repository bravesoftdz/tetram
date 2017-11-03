<?php

namespace BDTheque\DataModelBundle\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * BDTheque\DataModelBundle\Entity\ColoristeSerie
 * 
 * @ORM\Entity
 */
class ColoristeSerie extends AuteurSerie {

    public function setSerie(Serie $serie) {
        $serie->addColoriste($this);
        return parent::setSerie($serie);
    }

}

?>