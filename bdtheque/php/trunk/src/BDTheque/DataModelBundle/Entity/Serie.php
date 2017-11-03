<?php

namespace BDTheque\DataModelBundle\Entity;

use Doctrine\ORM\Mapping as ORM;
use BDTheque\DataModelBundle\Utils\StringUtils;

/**
 * BDTheque\DataModelBundle\Entity\Serie
 *
 * @ORM\Table(name="series")
 * @ORM\Entity(repositoryClass="BDTheque\DataModelBundle\Repository\SerieRepository")
 */
class Serie extends BaseEntityItem {

    /**
     * @var string $titre
     *
     * @ORM\Column(name="titre", type="string", length=255)
     */
    private $titre;

    /**
     * @var integer $terminee
     *
     * @ORM\Column(name="terminee", type="smallint", unique=false, nullable=true)
     */
    private $terminee;

    /**
     * @var string $sujet
     *
     * @ORM\Column(name="sujet", type="text", unique=false, nullable=true)
     */
    private $sujet;

    /**
     * @var string $notes
     *
     * @ORM\Column(name="notes", type="text", unique=false, nullable=true)
     */
    private $notes;

    /**
     * @var Collection $collection
     *
     * @ORM\ManyToOne(targetEntity="Collection", cascade={"all"}, fetch="LAZY")
     * @ORM\JoinColumn(nullable=true)
     */
    private $collection;

    /**
     * @var string $siteWeb
     *
     * @ORM\Column(name="siteWeb", type="string", length=255, unique=false, nullable=true)
     */
    private $siteWeb;

    /**
     * @var Genre[] $genres
     *
     * @ORM\ManyToMany(targetEntity="Genre")
     * @ORM\JoinTable(name="series_genres")
     */
    private $genres;

    /**
     * @var Editeur $editeur
     *
     * @ORM\ManyToOne(targetEntity="Editeur", cascade={"all"}, fetch="LAZY")
     * @ORM\JoinColumn(nullable=true)
     */
    private $editeur;

    /**
     * @var boolean $suivreManquants
     *
     * @ORM\Column(name="suivreManquants", type="boolean", unique=false, nullable=true)
     */
    private $suivreManquants;

    /**
     * @var boolean $complete
     *
     * @ORM\Column(name="complete", type="boolean", unique=false, nullable=true)
     */
    private $complete;

    /**
     * @var boolean $suivreSorties
     *
     * @ORM\Column(name="suivreSorties", type="boolean", unique=false, nullable=true)
     */
    private $suivreSorties;

    /**
     * @var integer $couleur
     *
     * @ORM\Column(name="couleur", type="smallint", unique=false, nullable=true)
     */
    private $couleur;

    /**
     * @var Album[] $albums
     * 
     * @ORM\OneToMany(targetEntity="Album", mappedBy="serie", cascade={"persist"}, orphanRemoval=false)
     */
    private $albums;

    /**
     * @var integer $nbAlbums
     *
     * @ORM\Column(name="nbAlbums", type="smallint", unique=false, nullable=true)
     */
    private $nbAlbums;

    /**
     * @var integer $vo
     *
     * @ORM\Column(name="vo", type="smallint", unique=false, nullable=true)
     */
    private $vo;

    /**
     * @var integer $notation
     *
     * @ORM\Column(name="notation", type="smallint", unique=false, nullable=true)
     */
    private $notation;

    /**
     * @var ScenaristeSerie[] 
     * 
     * @ORM\OneToMany(targetEntity="ScenaristeSerie", mappedBy="serie", cascade={"persist"}, orphanRemoval=true)     
     */
    private $scenaristes;

    /**
     * @var DessinateurSerie[]
     * 
     * @ORM\OneToMany(targetEntity="DessinateurSerie", mappedBy="serie", cascade={"persist"}, orphanRemoval=true)     
     */
    private $dessinateurs;

    /**
     * @var ColoristeSerie[]
     * 
     * @ORM\OneToMany(targetEntity="ColoristeSerie", mappedBy="serie", cascade={"persist"}, orphanRemoval=true)     
     */
    private $coloristes;

    public function __construct() {
        $this->albums = new \Doctrine\Common\Collections\ArrayCollection();
        $this->scenaristes = new \Doctrine\Common\Collections\ArrayCollection();
        $this->dessinateurs = new \Doctrine\Common\Collections\ArrayCollection();
        $this->coloristes = new \Doctrine\Common\Collections\ArrayCollection();
        $this->genres = new \Doctrine\Common\Collections\ArrayCollection();
    }

    public function getLabel() {
        return StringUtils::buildTitreSerie(false, $this->titre, $this->editeur, $this->collection);
    }

    /**
     * Set titre
     *
     * @param string $titre
     * @return Serie
     */
    public function setTitre($titre) {
        $this->titre = $titre;
        $this->setInitiale(StringUtils::extractInitialeFromString($titre));

        return $this;
    }

    /**
     * Get titre
     *
     * @return string 
     */
    public function getTitre() {
        return $this->titre;
    }

    /**
     * Set terminee
     *
     * @param integer $terminee
     * @return Serie
     */
    public function setTerminee($terminee) {
        $this->terminee = $terminee;

        return $this;
    }

    /**
     * Get terminee
     *
     * @return integer 
     */
    public function getTerminee() {
        return $this->terminee;
    }

    /**
     * Set sujet
     *
     * @param string $sujet
     * @return Serie
     */
    public function setSujet($sujet) {
        $this->sujet = $sujet;

        return $this;
    }

    /**
     * Get sujet
     *
     * @return string 
     */
    public function getSujet() {
        return $this->sujet;
    }

    /**
     * Set notes
     *
     * @param string $notes
     * @return Serie
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
     * Set siteWeb
     *
     * @param string $siteWeb
     * @return Serie
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

    /**
     * @param Genre $genre
     * @return Serie
     */
    public function addGenre(Genre $genre) {
        $this->genres[] = $genre;
        return $this;
    }

    /**
     * @param Genre $genre
     */
    public function removeGenre(Genre $genre) {
        $this->genres->removeItem($genre);
    }

    /**
     * Get genres
     *
     * @return Doctrine\Common\Collections\Collection 
     */
    public function getGenres() {
        return $this->genres;
    }

    /**
     * Set suivreManquants
     *
     * @param boolean $suivreManquants
     * @return Serie
     */
    public function setSuivreManquants($suivreManquants) {
        $this->suivreManquants = $suivreManquants;

        return $this;
    }

    /**
     * Get suivreManquants
     *
     * @return boolean 
     */
    public function getSuivreManquants() {
        return $this->suivreManquants;
    }

    /**
     * Set complete
     *
     * @param boolean $complete
     * @return Serie
     */
    public function setComplete($complete) {
        $this->complete = $complete;

        return $this;
    }

    /**
     * Get complete
     *
     * @return boolean 
     */
    public function getComplete() {
        return $this->complete;
    }

    /**
     * Set suivreSorties
     *
     * @param boolean $suivreSorties
     * @return Serie
     */
    public function setSuivreSorties($suivreSorties) {
        $this->suivreSorties = $suivreSorties;

        return $this;
    }

    /**
     * Get suivreSorties
     *
     * @return boolean 
     */
    public function getSuivreSorties() {
        return $this->suivreSorties;
    }

    /**
     * Set couleur
     *
     * @param integer $couleur
     * @return Serie
     */
    public function setCouleur($couleur) {
        $this->couleur = $couleur;

        return $this;
    }

    /**
     * Get couleur
     *
     * @return integer 
     */
    public function getCouleur() {
        return $this->couleur;
    }

    /**
     * Set nbAlbums
     *
     * @param integer $nbAlbums
     * @return Serie
     */
    public function setNbAlbums($nbAlbums) {
        $this->nbAlbums = $nbAlbums;

        return $this;
    }

    /**
     * Get nbAlbums
     *
     * @return integer 
     */
    public function getNbAlbums() {
        return $this->nbAlbums;
    }

    /**
     * Set vo
     *
     * @param integer $vo
     * @return Serie
     */
    public function setVo($vo) {
        $this->vo = $vo;

        return $this;
    }

    /**
     * Get vo
     *
     * @return integer 
     */
    public function getVo() {
        return $this->vo;
    }

    /**
     * Set notation
     *
     * @param integer $notation
     * @return Serie
     */
    public function setNotation($notation) {
        $this->notation = $notation;

        return $this;
    }

    /**
     * Get notation
     *
     * @return integer 
     */
    public function getNotation() {
        return $this->notation;
    }

    /**
     * Set collection
     *
     * @param BDTheque\DataModelBundle\Entity\Collection $collection
     * @return Serie
     */
    public function setCollection(Collection $collection = null) {
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
     * Add albums
     *
     * @param BDTheque\DataModelBundle\Entity\Album $album
     * @return Serie
     */
    public function addAlbum(\BDTheque\DataModelBundle\Entity\Album $album) {
        if (!$this->albums->contains($album)) {
            $this->albums[] = $album;
            $album->setSerie($this);
        }

        return $this;
    }

    /**
     * Remove albums
     *
     * @param BDTheque\DataModelBundle\Entity\Album $album
     */
    public function removeAlbum(\BDTheque\DataModelBundle\Entity\Album $album) {
        if ($this->albums->contains($album)) {
            $this->albums->removeElement($album);
            $album->setSerie(null);
        }
    }

    /**
     * Get albums
     *
     * @return Doctrine\Common\Collections\Collection 
     */
    public function getAlbums() {
        return $this->albums;
    }

    /**
     * Set editeur
     *
     * @param BDTheque\DataModelBundle\Entity\Editeur $editeur
     * @return Serie
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
     * Add scenaristes
     *
     * @param BDTheque\DataModelBundle\Entity\Personne $scenariste
     * @return Album
     */
    public function addScenariste(Personne $scenariste) {
        if (!Auteur::existsAuteurIntoList($this->scenaristes, $scenariste))
            $this->scenaristes[] = new ScenaristeSerie($this, $scenariste);

        return $this;
    }

    /**
     * Remove scenaristes
     *
     * @param BDTheque\DataModelBundle\Entity\Personne $scenariste
     */
    public function removeScenariste(Personne $scenariste) {
        if (Auteur::getAuteurIntoList($this->scenaristes, $scenariste, $auteur))
            $this->scenaristes->removeElement($auteur);
    }

    /**
     * Get scenaristes
     *
     * @return Doctrine\Common\Collections\Collection 
     */
    public function getScenaristes() {
        return $this->scenaristes;
    }

    /**
     * Add dessinateurs
     *
     * @param BDTheque\DataModelBundle\Entity\Personne $dessinateur
     * @return Album
     */
    public function addDessinateur(Personne $dessinateur) {
        if (!Auteur::existsAuteurIntoList($this->dessinateurs, $dessinateur))
            $this->dessinateurs[] = new DessinateurSerie($this, $dessinateur);

        return $this;
    }

    /**
     * Remove dessinateurs
     *
     * @param BDTheque\DataModelBundle\Entity\Personne $dessinateur
     */
    public function removeDessinateur(Personne $dessinateur) {
        if (Auteur::getAuteurIntoList($this->dessinateurs, $dessinateur, $auteur))
            $this->dessinateurs->removeElement($auteur);
    }

    /**
     * Get dessinateurs
     *
     * @return Doctrine\Common\Collections\Collection 
     */
    public function getDessinateurs() {
        return $this->dessinateurs;
    }

    /**
     * Add coloristes
     *
     * @param BDTheque\DataModelBundle\Entity\Personne $coloriste
     * @return Album
     */
    public function addColoriste(Personne $coloriste) {
        if (!Auteur::existsAuteurIntoList($this->coloristes, $coloriste))
            $this->coloristes[] = new ColoristeSerie($this, $coloriste);

        return $this;
    }

    /**
     * Remove coloristes
     *
     * @param BDTheque\DataModelBundle\Entity\Personne $coloriste
     */
    public function removeColoriste(Personne $coloriste) {
        if (Auteur::getAuteurIntoList($this->coloristes, $coloriste, $auteur))
            $this->coloristes->removeElement($auteur);
    }

    /**
     * Get coloristes
     *
     * @return Doctrine\Common\Collections\Collection 
     */
    public function getColoristes() {
        return $this->coloristes;
    }

}

?>