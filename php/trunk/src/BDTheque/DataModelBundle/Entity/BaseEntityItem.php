<?php

namespace BDTheque\DataModelBundle\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * BDTheque\DataModelBundle\Entity\BaseEntity
 *
 * @ORM\MappedSuperclass
 * @ORM\HasLifecycleCallbacks
 */
abstract class BaseEntityItem extends BaseEntity {

    /**
     * @var string
     * @ORM\Column(name="initiale", type="string", length=1, nullable=false, unique=false)
     */
    protected $initiale;

    public function setInitiale($initiale) {
        $this->initiale = $initiale;
    }

    public function getInitiale() {
        return $this->initiale;
    }

}

?>
