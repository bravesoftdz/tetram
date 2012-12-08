<?php

namespace BDTheque\DataModelBundle\Manager;

use Doctrine\ORM\EntityManager;
use BDTheque\DataModelBundle\Manager\BaseManager;
use BDTheque\DataModelBundle\Entity\Edition;

class EditionManager extends BaseManager {

    protected $em;

    public function __construct(EntityManager $em) {
        $this->em = $em;
    }

    public function getRepository() {
        return $this->em->getRepository('BDThequeDataModelBundle:Edition');
    }

    public function loadEdition($editionId) {
        return $this->getRepository()
                        ->findOneBy(array('id' => $editionId));
    }

    public function saveEdition(Edition $edition) {
        $this->persistAndFlush($edition);
    }

}