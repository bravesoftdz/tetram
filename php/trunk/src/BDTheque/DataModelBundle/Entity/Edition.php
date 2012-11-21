<?php

namespace BDTheque\DataModelBundle\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * BDTheque\DataModelBundle\Entity\Edition
 *
 * @ORM\Table(name="editions")
 * @ORM\Entity(repositoryClass="BDTheque\DataModelBundle\Entity\EditionRepository")
 */
class Edition extends BaseEntity {

    /**
     * @var boolean $stock
     *
     * @ORM\Column(name="stock", type="boolean")
     */
    private $stock;

    /**
     * @var Image[] $couvertures
     *
     * @ORM\OneToMany(targetEntity="Image", mappedBy="edition", cascade={"persist"}, orphanRemoval=true)
     */
    private $images;

    /**
     * @var float $prix
     *
     * @ORM\Column(name="prix", type="decimal", precision=2, nullable=true)
     */
    private $prix;

    /**
     * @var integer $anneeCote
     *
     * @ORM\Column(name="anneeCote", type="integer", nullable=true)
     */
    private $anneeCote;

    /**
     * @var string $isbn
     *
     * @ORM\Column(name="isbn", type="string", length=255, nullable=true)
     */
    private $isbn;

    /**
     * @var boolean $gratuit
     *
     * @ORM\Column(name="gratuit", type="boolean")
     */
    private $gratuit;

    /**
     * @var boolean $prete
     *
     * @ORM\Column(name="prete", type="boolean")
     */
    private $prete;

    /**
     * @var integer $nombreDePages
     *
     * @ORM\Column(name="nombreDePages", type="integer", nullable=true)
     */
    private $nombreDePages;

    /**
     * @var string $numeroPerso
     *
     * @ORM\Column(name="numeroPerso", type="string", length=255, nullable=true)
     */
    private $numeroPerso;

    /**
     * @var string $notes
     *
     * @ORM\Column(name="notes", type="text", nullable=true)
     */
    private $notes;

    /**
     * @var integer $anneeEdition
     *
     * @ORM\Column(name="anneeEdition", type="integer", nullable=true)
     */
    private $anneeEdition;

    /**
     * @var boolean $dedicace
     *
     * @ORM\Column(name="dedicace", type="boolean")
     */
    private $dedicace;

    /**
     * @var boolean $couleur
     *
     * @ORM\Column(name="couleur", type="boolean")
     */
    private $couleur;

    /**
     * @var Collection $collection
     *
     * @ORM\ManyToOne(targetEntity="Collection", cascade={"all"}, fetch="LAZY")
     * @ORM\JoinColumn(nullable=true)
     */
    private $collection;

    /**
     * @var float $prixCote
     *
     * @ORM\Column(name="prixCote", type="decimal", precision=2, nullable=true)
     */
    private $prixCote;

    /**
     * @var \DateTime $dateAchat
     *
     * @ORM\Column(name="dateAchat", type="date", nullable=true)
     */
    private $dateAchat;

    /**
     * @var boolean $offert
     *
     * @ORM\Column(name="offert", type="boolean")
     */
    private $offert;

    /**
     * @var Editeur $editeur
     *
     * @ORM\ManyToOne(targetEntity="Editeur", cascade={"all"}, fetch="LAZY")
     * @ORM\JoinColumn(nullable=false)
     */
    private $editeur;

    /**
     * @var Album $album
     *
     * @ORM\ManyToOne(targetEntity="Album", cascade={"all"}, fetch="LAZY", inversedBy="editions")
     * @ORM\JoinColumn(nullable=false)
     */
    private $album;

    /**
     * @var boolean $vo
     *
     * @ORM\Column(name="vo", type="boolean")
     */
    private $vo;

    public function __construct() {
        $this->images = new \Doctrine\Common\Collections\ArrayCollection();
    }

    /**
     * Set stock
     *
     * @param boolean $stock
     * @return Edition
     */
    public function setStock($stock) {
        $this->stock = $stock;

        return $this;
    }

    /**
     * Get stock
     *
     * @return boolean 
     */
    public function getStock() {
        return $this->stock;
    }

    /**
     * Set prix
     *
     * @param float $prix
     * @return Edition
     */
    public function setPrix($prix) {
        $this->prix = $prix;

        return $this;
    }

    /**
     * Get prix
     *
     * @return float 
     */
    public function getPrix() {
        return $this->prix;
    }

    /**
     * Set anneeCote
     *
     * @param integer $anneeCote
     * @return Edition
     */
    public function setAnneeCote($anneeCote) {
        $this->anneeCote = $anneeCote;

        return $this;
    }

    /**
     * Get anneeCote
     *
     * @return integer 
     */
    public function getAnneeCote() {
        return $this->anneeCote;
    }

    /**
     * Set isbn
     *
     * @param string $isbn
     * @return Edition
     */
    public function setIsbn($isbn) {
        $this->isbn = $isbn;

        return $this;
    }

    /**
     * Get isbn
     *
     * @return string 
     */
    public function getIsbn() {
        return $this->isbn;
    }

    /**
     * Set gratuit
     *
     * @param boolean $gratuit
     * @return Edition
     */
    public function setGratuit($gratuit) {
        $this->gratuit = $gratuit;

        return $this;
    }

    /**
     * Get gratuit
     *
     * @return boolean 
     */
    public function getGratuit() {
        return $this->gratuit;
    }

    /**
     * Set prete
     *
     * @param boolean $prete
     * @return Edition
     */
    public function setPrete($prete) {
        $this->prete = $prete;

        return $this;
    }

    /**
     * Get prete
     *
     * @return boolean 
     */
    public function getPrete() {
        return $this->prete;
    }

    /**
     * Set nombreDePages
     *
     * @param integer $nombreDePages
     * @return Edition
     */
    public function setNombreDePages($nombreDePages) {
        $this->nombreDePages = $nombreDePages;

        return $this;
    }

    /**
     * Get nombreDePages
     *
     * @return integer 
     */
    public function getNombreDePages() {
        return $this->nombreDePages;
    }

    /**
     * Set numeroPerso
     *
     * @param string $numeroPerso
     * @return Edition
     */
    public function setNumeroPerso($numeroPerso) {
        $this->numeroPerso = $numeroPerso;

        return $this;
    }

    /**
     * Get numeroPerso
     *
     * @return string 
     */
    public function getNumeroPerso() {
        return $this->numeroPerso;
    }

    /**
     * Set notes
     *
     * @param string $notes
     * @return Edition
     */
    public function setNotes($notes) {
        $this->notes = $notes;

        return $this;
    }

    /**
     * Get notes
     *
     * @return string 
     */
    public function getNotes() {
        return $this->notes;
    }

    /**
     * Set anneeEdition
     *
     * @param integer $anneeEdition
     * @return Edition
     */
    public function setAnneeEdition($anneeEdition) {
        $this->anneeEdition = $anneeEdition;

        return $this;
    }

    /**
     * Get anneeEdition
     *
     * @return integer 
     */
    public function getAnneeEdition() {
        return $this->anneeEdition;
    }

    /**
     * Set dedicace
     *
     * @param boolean $dedicace
     * @return Edition
     */
    public function setDedicace($dedicace) {
        $this->dedicace = $dedicace;

        return $this;
    }

    /**
     * Get dedicace
     *
     * @return boolean 
     */
    public function getDedicace() {
        return $this->dedicace;
    }

    /**
     * Set couleur
     *
     * @param boolean $couleur
     * @return Edition
     */
    public function setCouleur($couleur) {
        $this->couleur = $couleur;

        return $this;
    }

    /**
     * Get couleur
     *
     * @return boolean 
     */
    public function getCouleur() {
        return $this->couleur;
    }

    /**
     * Set collection
     *
     * @param BDTheque\DataModelBundle\Entity\Collection $collection
     * @return Edition
     */
    public function setCollection(Collection $collection) {
        $this->collection = $collection;

        return $this;
    }

    /**
     * Get collection
     *
     * @return BDTheque\DataModelBundle\Entity\Collection
     */
    public function getCollection() {
        return $this->collection;
    }

    /**
     * Set prixCote
     *
     * @param float $prixCote
     * @return Edition
     */
    public function setPrixCote($prixCote) {
        $this->prixCote = $prixCote;

        return $this;
    }

    /**
     * Get prixCote
     *
     * @return float 
     */
    public function getPrixCote() {
        return $this->prixCote;
    }

    /**
     * Set dateAchat
     *
     * @param \DateTime $dateAchat
     * @return Edition
     */
    public function setDateAchat(\DateTime $dateAchat) {
        $this->dateAchat = $dateAchat;

        return $this;
    }

    /**
     * Get dateAchat
     *
     * @return \DateTime 
     */
    public function getDateAchat() {
        return $this->dateAchat;
    }

    /**
     * Set offert
     *
     * @param boolean $offert
     * @return Edition
     */
    public function setOffert($offert) {
        $this->offert = $offert;

        return $this;
    }

    /**
     * Get offert
     *
     * @return boolean 
     */
    public function getOffert() {
        return $this->offert;
    }

    /**
     * Set editeur
     *
     * @param BDTheque\DataModelBundle\Entity\Editeur $editeur
     * @return Edition
     */
    public function setEditeur(Editeur $editeur) {
        $this->editeur = $editeur;

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

    /**
     * Set album
     *
     * @param BDTheque\DataModelBundle\Entity\Album $album
     * @return Edition
     */
    public function setAlbum(Album $album) {
        if ($album == $this->album)
            return $this;

        if ($this->album != null)
            $this->album->removeEdition($this);
        $this->album = $album;
        if ($album != null)
            $album->addEdition($this);

        return $this;
    }

    /**
     * Get album
     *
     * @return Album
     */
    public function getAlbum() {
        return $this->album;
    }

    /**
     * Set vo
     *
     * @param boolean $vo
     * @return Edition
     */
    public function setVo($vo) {
        $this->vo = $vo;

        return $this;
    }

    /**
     * Get vo
     *
     * @return boolean 
     */
    public function getVo() {
        return $this->vo;
    }

    /**
     * Add image
     *
     * @param BDTheque\DataModelBundle\Entity\Image $image
     * @return Edition
     */
    public function addImage(Image $image) {
        if (!$this->images->contains($image)) {
            $this->images[] = $image;
            $image->setEdition($this);
        }

        return $this;
    }

    /**
     * Remove image
     *
     * @param BDTheque\DataModelBundle\Entity\Image $image
     */
    public function removeImage(Image $image) {
        if ($this->images->contains($image)) {
            $this->images->removeElement($image);
            $image->setEdition(null);
        }
    }

    /**
     * Get images
     *
     * @return Doctrine\Common\Collections\Collection 
     */
    public function getImages() {
        return $this->images;
    }

}