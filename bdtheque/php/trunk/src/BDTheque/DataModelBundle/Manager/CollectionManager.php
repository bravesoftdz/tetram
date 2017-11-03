<?php

namespace BDTheque\DataModelBundle\Manager;

use Doctrine\ORM\EntityManager;
use BDTheque\DataModelBundle\Manager\BaseManager;
use BDTheque\DataModelBundle\Entity\Collection;

class CollectionManager extends BaseManager {

    protected $em;

    public function __construct(EntityManager $em) {
        $this->em = $em;
    }

    public function getRepository() {
        return $this->em->getRepository('BDThequeDataModelBundle:Collection');
    }

    public function loadCollection($collectionId) {
        return $this->getRepository()
                        ->findOneBy(array('id' => $collectionId));
    }

    public function saveCollection(Collection $collection) {
        $this->persistAndFlush($collection);
    }

}

?>