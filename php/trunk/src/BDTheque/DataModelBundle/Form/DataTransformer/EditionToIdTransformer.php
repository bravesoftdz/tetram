<?php

namespace BDTheque\DataModelBundle\Form\DataTransformer;

use Symfony\Component\Form\DataTransformerInterface;
use Symfony\Component\Form\Exception\TransformationFailedException;
use Doctrine\Common\Persistence\ObjectManager;
use BDTheque\DataModelBundle\Entity\Edition;

class EditionToIdTransformer implements DataTransformerInterface {

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
     * @param  Edition|null $edition
     * @return string
     */
    public function transform($edition) {
        if (null === $edition) {
            return "";
        }

        return $edition->getId();
    }

    /**
     * @param  string $id
     * @return Edition|null
     * @throws TransformationFailedException if object is not found.
     */
    public function reverseTransform($id) {
        if (!$id) {
            return null;
        }

        $edition = $this->om
                ->getRepository('BDThequeDataModelBundle:Edition')
                ->findOneBy(array('id' => $id))
        ;

        if (null === $edition) {
            throw new TransformationFailedException(sprintf('Une edition avec l\'id "%s" n\'existe pas!', $id));
        }

        return $edition;
    }

}

?>
