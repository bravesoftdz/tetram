<?php

namespace BDTheque\DataModelBundle\Form\DataTransformer;

use Symfony\Component\Form\DataTransformerInterface;
use Symfony\Component\Form\Exception\TransformationFailedException;
use Doctrine\Common\Persistence\ObjectManager;
use BDTheque\DataModelBundle\Entity\Album;

class AlbumToIdTransformer implements DataTransformerInterface {

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
     * @param  Album|null $album
     * @return string
     */
    public function transform($album) {
        if (null === $album) {
            return "";
        }

        return $album->getId();
    }

    /**
     * @param  string $id
     * @return Album|null
     * @throws TransformationFailedException if object is not found.
     */
    public function reverseTransform($id) {
        if (!$id) {
            return null;
        }

        $album = $this->om
                ->getRepository('BDThequeDataModelBundle:Album')
                ->findOneBy(array('id' => $id))
        ;

        if (null === $album) {
            throw new TransformationFailedException(sprintf('Un album avec l\'id "%s" n\'existe pas!', $id));
        }

        return $album;
    }

}

?>
