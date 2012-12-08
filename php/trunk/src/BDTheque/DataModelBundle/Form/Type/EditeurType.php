<?php

namespace BDTheque\DataModelBundle\Form\Type;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolverInterface;

class EditeurType extends AbstractType {

    public function buildForm(FormBuilderInterface $builder, array $options) {
        $builder
                ->add('version', 'datetime', array(
                    'widget' => 'single_text',
                    'read_only' => true,
                    'attr' => array(
                        'class' => 'uidatetime'
                        )))
                ->add('created', 'datetime', array('read_only' => true))
                ->add('nomEditeur')
                ->add('siteWeb')
                ->add('initiale', 'text', array('read_only' => true))
        ;
//                ->add('version', 'hidden')
//                ->add('created', 'datetime', array('read_only' => true))
//                ->add('nomEditeur')
//                ->add('siteWeb')
//                ->add('initiale', 'text', array('read_only' => true))
    }

    public function setDefaultOptions(OptionsResolverInterface $resolver) {
        $resolver->setDefaults(array(
            'data_class' => 'BDTheque\DataModelBundle\Entity\Editeur'
        ));
    }

    public function getName() {
        return 'bdtheque_datamodelbundle_editeurtype';
    }

}
