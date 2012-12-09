<?php

namespace BDTheque\DataModelBundle\Manager;

use Doctrine\ORM\EntityManager;
use BDTheque\DataModelBundle\Manager\BaseManager;
use BDTheque\DataModelBundle\Entity\Image;

class ImageManager extends BaseManager {

    protected $em;

    public function __construct(EntityManager $em) {
        $this->em = $em;
    }

    public function getRepository() {
        return $this->em->getRepository('BDThequeDataModelBundle:Image');
    }

    public function loadImage($imageId) {
        return $this->getRepository()
                        ->findOneBy(array('id' => $imageId));
    }

    public function saveImage(Image $image) {
        $this->persistAndFlush($image);
    }

}

?>