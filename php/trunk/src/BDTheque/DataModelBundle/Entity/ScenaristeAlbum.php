<?php

namespace BDTheque\DataModelBundle\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * BDTheque\DataModelBundle\Entity\ScenaristeAlbum
 *
 * @ORM\Entity
 */
class ScenaristeAlbum extends AuteurAlbum {

    public function setAlbum(Album $album) {
        $album->addScenariste($this);
        return parent::setAlbum($album);
    }

}

?>