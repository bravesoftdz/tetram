<?php

namespace BDTheque\DataModelBundle\Entity;

use Doctrine\ORM\Mapping as ORM;
use BDTheque\DataModelBundle\Utils\StringUtils;

/**
 * BDTheque\DataModelBundle\Entity\Collection
 * 
 * @ORM\Table(
 *      name="collections", 
 *      uniqueConstraints={
 *          @ORM\UniqueConstraint(name="collection_idx", columns={"nomCollection","editeur_id"})
 *      })
 * @ORM\Entity(repositoryClass="BDTheque\DataModelBundle\Entity\CollectionRepository")
 */
class Collection extends BaseEntityItem {

    /**
     * @var string $nomCollection
     * 
     * @ORM\Column(name="nomCollection", type="string", length=50, unique=false, nullable=false)
     */
    private $nomCollection;

    /**
     * @var Editeur $editeur
     * 
     * @ORM\ManyToOne(targetEntity="Editeur", cascade={"all"}, fetch="LAZY", inversedBy="collections")
     * @ORM\JoinColumn(nullable=false)
     * 
     */
    private $editeur;

    public function __toString() {
        return StringUtils::formatTitre($this->nomCollection);
    }

    /**
     * Set nomCollection
     *
     * @param string $nomCollection
     * @return Collection
     */
    public function setNomCollection($nomCollection) {
        $this->nomCollection = $nomCollection;
        $this->setInitiale(StringUtils::extractInitialeFromString($nomCollection));

        return $this;
    }

    /**
     * Get nomCollection
     *
     * @return string 
     */
    public function getNomCollection() {
        return $this->nomCollection;
    }

    /**
     * Set editeur
     *
     * @param BDTheque\DataModelBundle\Entity\Editeur $editeur
     * @return Collection
     */
    public function setEditeur(Editeur $editeur) {
        if ($editeur == $this->editeur)
            return $this;

        if ($this->editeur != null)
            $this->editeur->removeCollection($this);
        $this->editeur = $editeur;
        if ($editeur == null)
            $editeur->addCollection($this);

        return $this;
    }

    /**
     * Get editeur
     *
     * @return BDTheque\DataModelBundle\Entity\Editeur 
     */
    public function getEditeur() {
        return $this->editeur;
    }

}