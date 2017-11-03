<?php

namespace BDTheque\DataModelBundle\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * BDTheque\DataModelBundle\Entity\DessinateurAlbum
 *
 *  @ORM\Entity
 */
class DessinateurAlbum extends AuteurAlbum {

    public function setAlbum(Album $album) {
        $album->addDessinateur($this);
        return parent::setAlbum($album);
    }

}

?>