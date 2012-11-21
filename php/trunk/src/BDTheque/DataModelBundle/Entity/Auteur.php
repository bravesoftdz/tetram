<?php

namespace BDTheque\DataModelBundle\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * BDTheque\DataModelBundle\Entity\Auteur
 * @ORM\MappedSuperclass
 */
abstract class Auteur extends BaseEntityRelation {

    /**
     * @var Personne
     *
     * @ORM\ManyToOne(targetEntity="Personne", cascade={"all"}, fetch="LAZY")
     * @ORM\JoinColumn(nullable=false)
     */
    private $personne;

    /**
     * Set personne
     *
     * @param Personne $personne
     * @return Auteur
     */
    public function setPersonne(Personne $personne) {
        $this->personne = $personne;

        return $this;
    }

    /**
     * Get personne
     *
     * @return Personne
     */
    public function getPersonne() {
        return $this->personne;
    }

    /**
     * @param \Doctrine\Common\Collections\Collection $list
     * @return boolean
     */
    public function searchforIntoList(\Doctrine\Common\Collections\Collection $list) {
        return existsAuteurIntoList($list, $this);
    }

    /**
     * @param \Doctrine\Common\Collections\Collection $list
     * @param \BDTheque\DataModelBundle\Entity\Personne $item
     * @return boolean
     */
    public static function existsAuteurIntoList(\Doctrine\Common\Collections\Collection $list, Personne $item) {
        return Auteur::lookforAuteurIntoList($list, $item) != null;
    }

    /**
     * @param \Doctrine\Common\Collections\Collection $list
     * @param \BDTheque\DataModelBundle\Entity\Personne $item
     * @return boolean
     */
    public static function getAuteurIntoList(\Doctrine\Common\Collections\Collection $list, Personne $item, Auteur &$auteur) {
        $auteur = Auteur::lookforAuteurIntoList($list, $item);
        return $auteur != null;
    }

    /**
     * @param \Doctrine\Common\Collections\Collection $list
     * @param \BDTheque\DataModelBundle\Entity\Personne $item
     * @return \BDTheque\DataModelBundle\Entity\Auteur
     */
    public static function lookforAuteurIntoList(\Doctrine\Common\Collections\Collection $list, Personne $item) {
        return;
        foreach ($list->getValues() as $element)
            if ($item->getId() == $element->getPersonne()->getId())
                return $element;
    }

}
