<?php

namespace BDTheque\DataModelBundle\Form\DataTransformer;

use Symfony\Component\Form\DataTransformerInterface;
use Symfony\Component\Form\Exception\TransformationFailedException;
use Doctrine\Common\Persistence\ObjectManager;
use BDTheque\DataModelBundle\Entity\Genre;

class GenreToIdTransformer implements DataTransformerInterface {

    /**
     * @var ObjectManager
     */
    private $om;

    /**
     * @param ObjectManager $om
     */
    public function __construct(ObjectManager $om) {
        $this->om = $om;
    }

    /**
     * @param  Genre|null $genre
     * @return string
     */
    public function transform($genre) {
        if (null === $genre) {
            return "";
        }

        return $genre->getId();
    }

    /**
     * @param  string $id
     * @return Genre|null
     * @throws TransformationFailedException if object is not found.
     */
    public function reverseTransform($id) {
        if (!$id) {
            return null;
        }

        $genre = $this->om
                ->getRepository('BDThequeDataModelBundle:Genre')
                ->findOneBy(array('id' => $id))
        ;

        if (null === $genre) {
            throw new TransformationFailedException(sprintf('Un genre avec l\'id "%s" n\'existe pas!', $id));
        }

        return $genre;
    }

}

?>
