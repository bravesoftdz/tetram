<?php

namespace BDTheque\DataModelBundle\Entity;

use Doctrine\ORM\Mapping as ORM;
use BDTheque\DataModelBundle\Utils\StringUtils;

/**
 * BDTheque\DataModelBundle\Entity\Album
 *
 * @ORM\Table(name="albums")
 * @ORM\Entity(repositoryClass="BDTheque\DataModelBundle\Entity\AlbumRepository")
 */
class Album extends BaseEntityItem {

    /**
     * @var string $titre
     *
     * @ORM\Column(name="titre", type="string", length=255, nullable=false, unique=true)
     */
    private $titre;

    /**
     * @var Serie $serie
     *
     * @ORM\ManyToOne(targetEntity="Serie", cascade={"all"}, fetch="LAZY", inversedBy="albums")
     * @ORM\JoinColumn(nullable=true)
     */
    private $serie;

    /**
     * @var string $sujet
     *
     * @ORM\Column(name="sujet", type="text", unique=false, nullable=true)
     */
    private $sujet;

    /**
     * @var boolean $horsSerie
     *
     * @ORM\Column(name="horsSerie", type="boolean", unique=false, nullable=false)
     */
    private $horsSerie;

    /**
     * @var integer $moisParution
     *
     * @ORM\Column(name="moisParution", type="smallint", unique=false, nullable=true)
     */
    private $moisParution;

    /**
     * @var integer $tomeFin
     *
     * @ORM\Column(name="tomeFin", type="smallint", unique=false, nullable=true)
     */
    private $tomeFin;

    /**
     * @var string $notes
     *
     * @ORM\Column(name="notes", type="text", unique=false, nullable=true)
     */
    private $notes;

    /**
     * @var integer $anneeParution
     *
     * @ORM\Column(name="anneeParution", type="smallint", unique=false, nullable=true)
     */
    private $anneeParution;

    /**
     * @var boolean $integrale
     *
     * @ORM\Column(name="integrale", type="boolean", unique=false, nullable=false)
     */
    private $integrale;

    /**
     * @var integer $tomeDebut
     *
     * @ORM\Column(name="tomeDebut", type="smallint", unique=false, nullable=true)
     */
    private $tomeDebut;

    /**
     * @var integer $tome
     *
     * @ORM\Column(name="tome", type="smallint", unique=false, nullable=true)
     */
    private $tome;

    /**
     * @var Edition[] $editions
     *
     * @ORM\OneToMany(targetEntity="Edition", mappedBy="album", cascade={"persist"}, orphanRemoval=true)
     */
    private $editions;

    /**
     * @var boolean $complet
     *
     * @ORM\Column(name="complet", type="boolean", unique=false, nullable=false)
     */
    private $complet;

    /**
     * @var integer $notation
     *
     * @ORM\Column(name="notation", type="smallint", unique=false, nullable=true)
     */
    private $notation;

    /**
     * @var ScenaristeAlbum[]
     * 
     * @ORM\OneToMany(targetEntity="ScenaristeAlbum", mappedBy="album")
     */
    private $scenaristes;

    /**
     * @var DessinateurAlbum[]
     * 
     * @ORM\OneToMany(targetEntity="DessinateurAlbum", mappedBy="album")
     */
    private $dessinateurs;

    /**
     * @var ColoristeAlbum[]
     * 
     * @ORM\OneToMany(targetEntity="ColoristeAlbum", mappedBy="album")
     */
    private $coloristes;

    public function __construct() {
        $this->editions = new \Doctrine\Common\Collections\ArrayCollection();
        $this->scenaristes = new \Doctrine\Common\Collections\ArrayCollection();
        $this->dessinateurs = new \Doctrine\Common\Collections\ArrayCollection();
        $this->coloristes = new \Doctrine\Common\Collections\ArrayCollection();
    }

    /**
     * Set titre
     *
     * @param string $titre
     * @return Album
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
     * Set sujet
     *
     * @param string $sujet
     * @return Album
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
     * Set horsSerie
     *
     * @param boolean $horsSerie
     * @return Album
     */
    public function setHorsSerie($horsSerie) {
        $this->horsSerie = $horsSerie;

        return $this;
    }

    /**
     * Get horsSerie
     *
     * @return boolean 
     */
    public function getHorsSerie() {
        return $this->horsSerie;
    }

    /**
     * Set moisParution
     *
     * @param integer $moisParution
     * @return Album
     */
    public function setMoisParution($moisParution) {
        $this->moisParution = $moisParution;

        return $this;
    }

    /**
     * Get moisParution
     *
     * @return integer 
     */
    public function getMoisParution() {
        return $this->moisParution;
    }

    /**
     * Set tomeFin
     *
     * @param integer $tomeFin
     * @return Album
     */
    public function setTomeFin($tomeFin) {
        $this->tomeFin = $tomeFin;

        return $this;
    }

    /**
     * Get tomeFin
     *
     * @return integer 
     */
    public function getTomeFin() {
        return $this->tomeFin;
    }

    /**
     * Set notes
     *
     * @param string $notes
     * @return Album
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
     * Set anneeParution
     *
     * @param integer $anneeParution
     * @return Album
     */
    public function setAnneeParution($anneeParution) {
        $this->anneeParution = $anneeParution;

        return $this;
    }

    /**
     * Get anneeParution
     *
     * @return integer 
     */
    public function getAnneeParution() {
        return $this->anneeParution;
    }

    /**
     * Set integrale
     *
     * @param boolean $integrale
     * @return Album
     */
    public function setIntegrale($integrale) {
        $this->integrale = $integrale;

        return $this;
    }

    /**
     * Get integrale
     *
     * @return boolean 
     */
    public function getIntegrale() {
        return $this->integrale;
    }

    /**
     * Set tomeDebut
     *
     * @param integer $tomeDebut
     * @return Album
     */
    public function setTomeDebut($tomeDebut) {
        $this->tomeDebut = $tomeDebut;

        return $this;
    }

    /**
     * Get tomeDebut
     *
     * @return integer 
     */
    public function getTomeDebut() {
        return $this->tomeDebut;
    }

    /**
     * Set tome
     *
     * @param integer $tome
     * @return Album
     */
    public function setTome($tome) {
        $this->tome = $tome;

        return $this;
    }

    /**
     * Get tome
     *
     * @return integer 
     */
    public function getTome() {
        return $this->tome;
    }

    /**
     * Set complet
     *
     * @param boolean $complet
     * @return Album
     */
    public function setComplet($complet) {
        $this->complet = $complet;

        return $this;
    }

    /**
     * Get complet
     *
     * @return boolean 
     */
    public function getComplet() {
        return $this->complet;
    }

    /**
     * Set notation
     *
     * @param integer $notation
     * @return Album
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
     * Set serie
     *
     * @param BDTheque\DataModelBundle\Entity\Serie $serie
     * @return Album
     */
    public function setSerie(Serie $serie = null) {
        if ($serie == $this->serie)
            return $this;

        if ($this->$serie != null)
            $this->serie->removeAlbum($this);
        $this->serie = $serie;
        if ($serie != null)
            $serie->addAlbum($this);

        return $this;
    }

    /**
     * Get serie
     *
     * @return BDTheque\DataModelBundle\Entity\Serie 
     */
    public function getSerie() {
        return $this->serie;
    }

    /**
     * Add editions
     *
     * @param BDTheque\DataModelBundle\Entity\Edition $edition
     * @return Album
     */
    public function addEdition(Edition $edition) {
        if (!$this->editions->contains($edition)) {
            $this->editions[] = $edition;
            $edition->setAlbum(null);
        }

        return $this;
    }

    /**
     * Remove editions
     *
     * @param BDTheque\DataModelBundle\Entity\Edition $edition
     */
    public function removeEdition(Edition $edition) {
        if ($this->editions->contains($edition)) {
            $this->editions->removeElement($edition);
            $edition->setAlbum(null);
        }
    }

    /**
     * Get editions
     *
     * @return Doctrine\Common\Collections\Collection 
     */
    public function getEditions() {
        return $this->editions;
    }

    /**
     * Add scenaristes
     *
     * @param BDTheque\DataModelBundle\Entity\Personne $scenariste
     * @return Album
     */
    public function addScenariste(Personne $scenariste) {
        if (!Auteur::searchforAuteurIntoList($this->scenaristes, $scenariste))
            $this->scenaristes[] = new ScenaristeAlbum($this, $scenariste);

        return $this;
    }

    /**
     * Remove scenaristes
     *
     * @param BDTheque\DataModelBundle\Entity\Personne $scenariste
     */
    public function removeScenariste(Personne $scenariste) {
        $this->scenaristes->removeElement($scenariste);
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
        if (!Auteur::searchforAuteurIntoList($this->dessinateurs, $dessinateur))
            $this->dessinateurs[] = new DessinateurAlbum($this, $dessinateur);

        return $this;
    }

    /**
     * Remove dessinateurs
     *
     * @param BDTheque\DataModelBundle\Entity\Personne $dessinateur
     */
    public function removeDessinateur(Personne $dessinateur) {
        $this->dessinateurs->removeElement($dessinateur);
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
        if (!$this->coloristes->contains($coloriste))
            $this->coloristes[] = $coloriste;

        return $this;
    }

    /**
     * Remove coloristes
     *
     * @param BDTheque\DataModelBundle\Entity\Personne $coloriste
     */
    public function removeColoriste(Personne $coloriste) {
        $this->coloristes->removeElement($coloriste);
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