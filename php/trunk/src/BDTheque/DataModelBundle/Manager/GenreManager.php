<?php

namespace BDTheque\DataModelBundle\Manager;

use Doctrine\ORM\EntityManager;
use BDTheque\DataModelBundle\Manager\BaseManager;
use BDTheque\DataModelBundle\Entity\Genre;

class GenreManager extends BaseManager {

    protected $em;

    public function __construct(EntityManager $em) {
        $this->em = $em;
    }

    public function getRepository() {
        return $this->em->getRepository('BDThequeDataModelBundle:Genre');
    }

    public function loadGenre($genreId) {
        return $this->getRepository()
                        ->findOneBy(array('id' => $genreId));
    }

    public function saveGenre(Genre $genre) {
        $this->persistAndFlush($genre);
    }

}

?>