<?php

namespace BDTheque\DataModelBundle\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * BDTheque\DataModelBundle\Entity\BaseEntity
 *
 * @ORM\MappedSuperclass
 * @ORM\HasLifecycleCallbacks
 */
abstract class BaseEntity {

    /**
     * @var integer $id
     *
     * @ORM\Column(name="id", type="integer")
     * @ORM\Id
     * @ORM\GeneratedValue(strategy="AUTO")
     */
    private $id;

    /**
     * @var \DateTime $version
     *
     * @ORM\Column(name="version", type="datetime")
     * @ORM\Version
     */
    private $version;

    /**
     * @var \DateTime
     * 
     * @ORM\Column(name="created", type="datetime")
     */
    private $created;

    /**
     * Get id
     *
     * @return integer 
     */
    public function getId() {
        return $this->id;
    }

    /**
     * Get version
     *
     * @return \DateTime 
     */
    public function getVersion() {
        return $this->version;
    }

    /**
     * @return \DateTime
     */
    public function getCreated() {
        return $this->created;
    }

    /**
     * @ORM\PrePersist
     */
    public function setDateCreation() {
        $this->created = new \DateTime("now");
    }

}
