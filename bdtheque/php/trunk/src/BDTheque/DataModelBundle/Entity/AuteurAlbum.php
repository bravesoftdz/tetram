<?php

namespace BDTheque\DataModelBundle\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * BDTheque\DataModelBundle\Entity\AuteurAlbum
 *
 * @ORM\Table(
 *      name="albums_auteurs", 
 *      uniqueConstraints={
 *          @ORM\UniqueConstraint(name="auteur_idx", columns={"personne_id","album_id","metier"})
 *      })
 * @ORM\Entity
 * @ORM\InheritanceType("SINGLE_TABLE")
 * @ORM\DiscriminatorColumn(name="metier", type="string", length=1)
 * @ORM\DiscriminatorMap({"S" = "ScenaristeAlbum", "D" = "DessinateurAlbum", "C" = "ColoristeAlbum"})
 */
abstract class AuteurAlbum extends Auteur {

    /**
     * @var Album $album
     *
     * @ORM\ManyToOne(targetEntity="Album", cascade={"all"}, fetch="LAZY")
     * @ORM\JoinColumn(nullable=false)
     */
    private $album;

    public function __construct(Album $album, Personne $personne) {
        $this->album = $album;
        $this->setPersonne($personne);
    }

    /**
     * Set album
     *
     * @param Album $album
     * @return AuteurAlbum
     */
    public function setAlbum(Album $album) {
        $this->album = $album;

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

}

?>