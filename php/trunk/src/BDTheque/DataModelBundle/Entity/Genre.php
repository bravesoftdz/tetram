<?php

namespace BDTheque\DataModelBundle\Entity;

use Doctrine\ORM\Mapping as ORM;
use BDTheque\DataModelBundle\Utils\StringUtils;

/**
 * BDTheque\DataModelBundle\Entity\Genre
 *
 * @ORM\Table(name="genres")
 * @ORM\Entity(repositoryClass="BDTheque\DataModelBundle\Repository\GenreRepository")
 */
class Genre extends BaseEntityItem {

    /**
     * @var string $genre
     *
     * @ORM\Column(name="genre", type="string", length=255, unique=true, nullable=false)
     */
    private $genre;

    public function __toString() {
        return StringUtils::formatTitre($this->genre);
    }

    public function getLabel(){
        return StringUtils::formatTitre($this->genre);
    }
    
    /**
     * Set genre
     *
     * @param string $genre
     * @return Genre
     */
    public function setGenre($genre) {
        $this->genre = $genre;
        $this->setInitiale(StringUtils::extractInitialeFromString($genre));

        return $this;
    }

    /**
     * Get genre
     *
     * @return string 
     */
    public function getGenre() {
        return $this->genre;
    }

}

?>