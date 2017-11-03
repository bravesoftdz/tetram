<?php

namespace BDTheque\DataModelBundle\Form\DataTransformer;

use Symfony\Component\Form\DataTransformerInterface;
use Symfony\Component\Form\Exception\TransformationFailedException;
use Doctrine\Common\Persistence\ObjectManager;
use BDTheque\DataModelBundle\Entity\Collection;

class CollectionToIdTransformer implements DataTransformerInterface {

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
     * @param  Collection|null $collection
     * @return string
     */
    public function transform($collection) {
        if (null === $collection) {
            return "";
        }

        return $collection->getId();
    }

    /**
     * @param  string $id
     * @return Collection|null
     * @throws TransformationFailedException if object is not found.
     */
    public function reverseTransform($id) {
        if (!$id) {
            return null;
        }

        $collection = $this->om
                ->getRepository('BDThequeDataModelBundle:Collection')
                ->findOneBy(array('id' => $id))
        ;

        if (null === $collection) {
            throw new TransformationFailedException(sprintf('Une collection avec l\'id "%s" n\'existe pas!', $id));
        }

        return $collection;
    }

}

?>
