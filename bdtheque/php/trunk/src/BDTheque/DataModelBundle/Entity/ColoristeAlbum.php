<?php

namespace BDTheque\DataModelBundle\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * BDTheque\DataModelBundle\Entity\ColoristeAlbum
 * 
 * @ORM\Entity
 */
class ColoristeAlbum extends AuteurAlbum {

    public function setAlbum(Album $album) {
        $album->addColoriste($this);
        return parent::setAlbum($album);
    }

}

?>