<?php

namespace BDTheque\DataModelBundle\Form\DataTransformer;

use Symfony\Component\Form\DataTransformerInterface;
use Symfony\Component\Form\Exception\TransformationFailedException;
use Doctrine\Common\Persistence\ObjectManager;
use BDTheque\DataModelBundle\Entity\Editeur;

class EditeurToIdTransformer implements DataTransformerInterface {

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
     * @param  Editeur|null $editeur
     * @return string
     */
    public function transform($editeur) {
        if (null === $editeur) {
            return "";
        }

        return $editeur->getId();
    }

    /**
     * @param  string $id
     * @return Editeur|null
     * @throws TransformationFailedException if object is not found.
     */
    public function reverseTransform($id) {
        if (!$id) {
            return null;
        }

        $editeur = $this->om
                ->getRepository('BDThequeDataModelBundle:Editeur')
                ->findOneBy(array('id' => $id))
        ;

        if (null === $editeur) {
            throw new TransformationFailedException(sprintf('Un éditeur avec l\'id "%s" n\'existe pas!', $id));
        }

        return $editeur;
    }

}

?>
