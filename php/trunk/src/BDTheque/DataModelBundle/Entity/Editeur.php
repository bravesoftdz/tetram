<?php

namespace BDTheque\DataModelBundle\Entity;

use Doctrine\ORM\Mapping as ORM;
use BDTheque\DataModelBundle\Utils\StringUtils;

/**
 * BDTheque\DataModelBundle\Entity\Editeur
 *
 * @ORM\Table(name="editeurs")
 * @ORM\Entity(repositoryClass="BDTheque\DataModelBundle\Entity\EditeurRepository")
 */
class Editeur extends BaseEntityItem {

    /**
     * @var string $nomEditeur
     *
     * @ORM\Column(name="nomEditeur", type="string", length=50, unique=true, nullable=false)
     */
    private $nomEditeur;

    /**
     * @var string $siteWeb
     * 
     * @ORM\Column(type="string", length=255, unique=false, nullable=true)
     */
    private $siteWeb;

    /**
     * @var array<Collection> $collections
     * 
     * @ORM\OneToMany(targetEntity="Collection", mappedBy="editeur", cascade={"persist"}, orphanRemoval=true)
     */
    private $collections;

    public function __construct() {
        $this->collections = new \Doctrine\Common\Collections\ArrayCollection();
    }

    /**
     * Set nomEditeur
     *
     * @param string $nomEditeur
     * @return Editeur
     */
    public function setNomEditeur($nomEditeur) {
        $this->nomEditeur = $nomEditeur;
        $this->setInitiale(StringUtils::extractInitialeFromString($nomEditeur));

        return $this;
    }

    /**
     * Get nomEditeur
     *
     * @return string 
     */
    public function getNomEditeur() {
        return $this->nomEditeur;
    }

    /**
     * Add collections
     *
     * @param BDTheque\DataModelBundle\Entity\Collection $collection
     * @return Editeur
     */
    public function addCollection(Collection $collection) {
        if (!$this->collections->contains($collection)) {
            $this->collections[] = $collection;
            $collection->setEditeur($this);
        }

        return $this;
    }

    /**
     * Remove collections
     *
     * @param BDTheque\DataModelBundle\Entity\Collection $collection
     */
    public function removeCollection(Collection $collection) {
        if ($this->collections->contains($collection)) {
            $this->collections->removeElement($collection);
            $collection->setEditeur(null);
        }
    }

    /**
     * Get collections
     *
     * @return Doctrine\Common\Collections\Collection 
     */
    public function getCollections() {
        return $this->collections;
    }

    /**
     * Set siteWeb
     *
     * @param string $siteWeb
     * @return Editeur
     */
    public function setSiteWeb($siteWeb) {
        $this->siteWeb = $siteWeb;

        return $this;
    }

    /**
     * Get siteWeb
     *
     * @return string 
     */
    public function getSiteWeb() {
        return $this->siteWeb;
    }

}