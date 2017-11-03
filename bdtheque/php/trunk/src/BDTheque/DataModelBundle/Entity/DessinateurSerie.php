<?php

namespace BDTheque\DataModelBundle\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * BDTheque\DataModelBundle\Entity\DessinateurSerie
 * 
 * @ORM\Entity
 */
class DessinateurSerie extends AuteurSerie {

    public function setSerie(Serie $serie) {
        $serie->addDessinateur($this);
        return parent::setSerie($serie);
    }

}

?>