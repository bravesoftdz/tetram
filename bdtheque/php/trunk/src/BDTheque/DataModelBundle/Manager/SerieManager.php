<?php

namespace BDTheque\DataModelBundle\Manager;

use Doctrine\ORM\EntityManager;
use BDTheque\DataModelBundle\Manager\BaseManager;
use BDTheque\DataModelBundle\Entity\Serie;

class SerieManager extends BaseManager {

    protected $em;

    public function __construct(EntityManager $em) {
        $this->em = $em;
    }

    public function getRepository() {
        return $this->em->getRepository('BDThequeDataModelBundle:Serie');
    }

    public function loadSerie($serieId) {
        return $this->getRepository()
                        ->findOneBy(array('id' => $serieId));
    }

    public function saveSerie(Serie $serie) {
        $this->persistAndFlush($serie);
    }

}

?>