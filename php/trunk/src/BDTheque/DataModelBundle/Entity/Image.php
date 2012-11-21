<?php

namespace BDTheque\DataModelBundle\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * BDTheque\DataModelBundle\Entity\Image
 *
 * @ORM\Table(name="images")
 * @ORM\Entity(repositoryClass="BDTheque\DataModelBundle\Entity\ImageRepository")
 */
class Image extends BaseEntity {

    /**
     * @var string $nom
     *
     * @ORM\Column(name="nom", type="string", length=255, unique=false, nullable=false)
     */
    private $nom;

    /**
     * @var boolean $stockee
     *
     * @ORM\Column(name="stockee", type="boolean", unique=false, nullable=false)
     */
    private $stockee;

    /**
     * @var integer $categorie
     *
     * @ORM\Column(name="categorie", type="smallint", unique=false, nullable=false)
     */
    private $categorie;

    /**
     *
     * @var Edition $edition
     * 
     * @ORM\ManyToOne(targetEntity="Edition", cascade={"all"}, fetch="LAZY")
     * @ORM\JoinColumn(nullable=false)
     */
    private $edition;

    /**
     * Set nom
     *
     * @param string $nom
     * @return Image
     */
    public function setNom($nom) {
        $this->nom = $nom;

        return $this;
    }

    /**
     * Get nom
     *
     * @return string 
     */
    public function getNom() {
        return $this->nom;
    }

    /**
     * Set stockee
     *
     * @param boolean $stockee
     * @return Image
     */
    public function setStockee($stockee) {
        $this->stockee = $stockee;

        return $this;
    }

    /**
     * Get stockee
     *
     * @return boolean 
     */
    public function getStockee() {
        return $this->stockee;
    }

    /**
     * Set categorie
     *
     * @param integer $categorie
     * @return Image
     */
    public function setCategorie($categorie) {
        $this->categorie = $categorie;

        return $this;
    }

    /**
     * Get categorie
     *
     * @return integer 
     */
    public function getCategorie() {
        return $this->categorie;
    }

    /**
     * Set edition
     *
     * @param BDTheque\DataModelBundle\Entity\Edition $edition
     * @return Image
     */
    public function setEdition(Edition $edition) {
        if ($this->edition == $edition)
            return $this;

        if ($this->edition != null)
            $this->edition->removeImage($this);
        $this->edition = $edition;
        if ($edition != null)
            $edition->addImage($this);

        return $this;
    }

    /**
     * Get edition
     *
     * @return BDTheque\DataModelBundle\Entity\Edition 
     */
    public function getEdition() {
        return $this->edition;
    }

}