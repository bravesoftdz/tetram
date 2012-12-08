<?php

namespace BDTheque\DataModelBundle\Form\DataTransformer;

use Symfony\Component\Form\DataTransformerInterface;
use Symfony\Component\Form\Exception\TransformationFailedException;
use Doctrine\Common\Persistence\ObjectManager;
use BDTheque\DataModelBundle\Entity\Serie;

class SerieToIdTransformer implements DataTransformerInterface {

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
     * @param  Serie|null $serie
     * @return string
     */
    public function transform($serie) {
        if (null === $serie) {
            return "";
        }

        return $serie->getId();
    }

    /**
     * @param  string $id
     * @return Serie|null
     * @throws TransformationFailedException if object is not found.
     */
    public function reverseTransform($id) {
        if (!$id) {
            return null;
        }

        $serie = $this->om
                ->getRepository('BDThequeDataModelBundle:Serie')
                ->findOneBy(array('id' => $id))
        ;

        if (null === $serie) {
            throw new TransformationFailedException(sprintf('Une série avec l\'id "%s" n\'existe pas!', $id));
        }

        return $serie;
    }

}

?>
