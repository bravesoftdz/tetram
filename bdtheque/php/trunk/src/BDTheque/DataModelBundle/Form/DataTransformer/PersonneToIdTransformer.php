<?php

namespace BDTheque\DataModelBundle\Form\DataTransformer;

use Symfony\Component\Form\DataTransformerInterface;
use Symfony\Component\Form\Exception\TransformationFailedException;
use Doctrine\Common\Persistence\ObjectManager;
use BDTheque\DataModelBundle\Entity\Personne;

class PersonneToIdTransformer implements DataTransformerInterface {

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
     * @param  Personne|null $personne
     * @return string
     */
    public function transform($personne) {
        if (null === $personne) {
            return "";
        }

        return $personne->getId();
    }

    /**
     * @param  string $id
     * @return Personne|null
     * @throws TransformationFailedException if object is not found.
     */
    public function reverseTransform($id) {
        if (!$id) {
            return null;
        }

        $personne = $this->om
                ->getRepository('BDThequeDataModelBundle:Personne')
                ->findOneBy(array('id' => $id))
        ;

        if (null === $personne) {
            throw new TransformationFailedException(sprintf('Une personne avec l\'id "%s" n\'existe pas!', $id));
        }

        return $personne;
    }

}

?>
