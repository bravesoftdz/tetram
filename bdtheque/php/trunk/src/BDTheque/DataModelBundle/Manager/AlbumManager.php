<?php

namespace BDTheque\DataModelBundle\Manager;

use Doctrine\ORM\EntityManager;
use BDTheque\DataModelBundle\Manager\BaseManager;
use BDTheque\DataModelBundle\Entity\Album;

class AlbumManager extends BaseManager {

    protected $em;

    public function __construct(EntityManager $em) {
        $this->em = $em;
    }

    public function getRepository() {
        return $this->em->getRepository('BDThequeDataModelBundle:Album');
    }

    public function loadAlbum($albumId) {
        return $this->getRepository()
                        ->findOneBy(array('id' => $albumId));
    }

    public function saveAlbum(Album $album) {
        $this->persistAndFlush($album);
    }

}

?>