<?php

namespace BDTheque\DataModelBundle\Form\Type;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolverInterface;

class CollectionType extends AbstractType {

    public function buildForm(FormBuilderInterface $builder, array $options) {
        $builder
                ->add('version')
                ->add('created')
                ->add('nomCollection')
                ->add('initiale')
                ->add('editeur')
        ;
    }

    public function setDefaultOptions(OptionsResolverInterface $resolver) {
        $resolver->setDefaults(array(
            'data_class' => 'BDTheque\DataModelBundle\Entity\Collection'
        ));
    }

    public function getName() {
        return 'bdtheque_datamodelbundle_collectiontype';
    }

}

?>