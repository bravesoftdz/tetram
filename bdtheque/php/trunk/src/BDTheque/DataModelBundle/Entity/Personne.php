<?php

namespace BDTheque\DataModelBundle\Entity;

use Doctrine\ORM\Mapping as ORM;
use BDTheque\DataModelBundle\Utils\StringUtils;

/**
 * BDTheque\DataModelBundle\Entity\Personne
 *
 * @ORM\Table(name="personnes")
 * @ORM\Entity(repositoryClass="BDTheque\DataModelBundle\Repository\PersonneRepository")
 */
class Personne extends BaseEntityItem {

    /**
     * @var string $nom
     *
     * @ORM\Column(name="nom", type="string", length=255, nullable=false, unique=true)
     */
    private $nom;

    /**
     * @var string $biographie
     *
     * @ORM\Column(name="biographie", type="text", nullable=true)
     */
    private $biographie;

    /**
     * @var string $siteWeb
     *
     * @ORM\Column(name="siteWeb", type="string", length=255, nullable=true)
     */
    private $siteWeb;

    /**
     * Set nom
     *
     * @param string $nom
     * @return Personne
     */
    public function setNom($nom) {
        $this->nom = $nom;
        $this->setInitiale(StringUtils::extractInitialeFromString($nom));

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
     * Set biographie
     *
     * @param string $biographie
     * @return Personne
     */
    public function setBiographie($biographie) {
        $this->biographie = $biographie;

        return $this;
    }

    /**
     * Get biographie
     *
     * @return string 
     */
    public function getBiographie() {
        return $this->biographie;
    }

    /**
     * Set siteWeb
     *
     * @param string $siteWeb
     * @return Personne
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

?>