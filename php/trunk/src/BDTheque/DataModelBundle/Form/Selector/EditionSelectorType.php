<?php

namespace BDTheque\DataModelBundle\Form\Selector;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use BDTheque\DataModelBundle\Form\DataTransformer\EditionToIdTransformer;
use Doctrine\Common\Persistence\ObjectManager;
use Symfony\Component\OptionsResolver\OptionsResolverInterface;

class EditionSelectorType extends AbstractType {

    /**
     * @var ObjectManager
     */
    private $om;

    /**
     * @var boolean
     */
    private $hidden = false;

    /**
     * @param ObjectManager $om
     */
    public function __construct(ObjectManager $om) {
        $this->om = $om;
    }

    public function buildForm(FormBuilderInterface $builder, array $options) {
        $transformer = new EditionToIdTransformer($this->om);
        $builder->addModelTransformer($transformer);
        $this->hidden = isset($options['hidden']) ? $options['hidden'] === true : false;
    }

    public function setDefaultOptions(OptionsResolverInterface $resolver) {
        $resolver->setDefaults(array(
            'invalid_message' => 'L\'édition sélectionnée n\existe pas',
            'hidden' => false
        ));
    }

    public function getParent() {
        return $this->hidden ? 'hidden' : 'text';
    }

    public function getName() {
        return 'edition_selector';
    }

}

?>
