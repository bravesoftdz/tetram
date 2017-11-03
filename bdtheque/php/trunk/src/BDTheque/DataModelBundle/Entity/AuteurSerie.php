<?php

namespace BDTheque\DataModelBundle\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * BDTheque\DataModelBundle\Entity\AuteurSerie
 *
 * @ORM\Table(
 *      name="series_auteurs", 
 *      uniqueConstraints={
 *          @ORM\UniqueConstraint(name="auteur_idx", columns={"personne_id","serie_id","metier"})
 *      })
 * @ORM\Entity
 * @ORM\InheritanceType("SINGLE_TABLE")
 * @ORM\DiscriminatorColumn(name="metier", type="string", length=1)
 * @ORM\DiscriminatorMap({"S" = "ScenaristeSerie", "D" = "DessinateurSerie", "C" = "ColoristeSerie"})
 */
abstract class AuteurSerie extends Auteur {

    /**
     * @var Serie $serie
     *
     * @ORM\ManyToOne(targetEntity="Serie", cascade={"all"}, fetch="LAZY")
     * @ORM\JoinColumn(nullable=false)
     */
    private $serie;

    public function __construct(Serie $serie, Personne $personne) {
        $this->serie = $serie;
        $this->setPersonne($personne);
    }

    /**
     * Set serie
     *
     * @param Serie $serie
     * @return AuteurSerie
     */
    public function setSerie(Serie $serie) {
        $this->serie = $serie;

        return $this;
    }

    /**
     * Get serie
     *
     * @return Serie
     */
    public function getSerie() {
        return $this->serie;
    }

}

?>