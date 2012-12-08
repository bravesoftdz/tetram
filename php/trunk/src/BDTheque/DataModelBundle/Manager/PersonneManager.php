<?php

namespace BDTheque\DataModelBundle\Manager;

use Doctrine\ORM\EntityManager;
use BDTheque\DataModelBundle\Manager\BaseManager;
use BDTheque\DataModelBundle\Entity\Personne;

class PersonneManager extends BaseManager {

    protected $em;

    public function __construct(EntityManager $em) {
        $this->em = $em;
    }

    public function getRepository() {
        return $this->em->getRepository('BDThequeDataModelBundle:Personne');
    }

    public function loadPersonne($personneId) {
        return $this->getRepository()
                        ->findOneBy(array('id' => $personneId));
    }

    public function savePersonne(Personne $personne) {
        $this->persistAndFlush($personne);
    }

}