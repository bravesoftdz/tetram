<?php

namespace BDTheque\DataModelBundle\Manager;

use Doctrine\ORM\EntityManager;
use BDTheque\DataModelBundle\Manager\BaseManager;
use BDTheque\DataModelBundle\Entity\Editeur;

class EditeurManager extends BaseManager {

    protected $em;

    public function __construct(EntityManager $em) {
        $this->em = $em;
    }

    public function getRepository() {
        return $this->em->getRepository('BDThequeDataModelBundle:Editeur');
    }

    public function loadEditeur($editeurId) {
        return $this->getRepository()
                        ->findOneBy(array('id' => $editeurId));
    }

    public function saveEditeur(Editeur $editeur) {
        $this->persistAndFlush($editeur);
    }

}

?>