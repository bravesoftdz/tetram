<?php

namespace BDTheque\DataModelBundle\Form;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolverInterface;

class EditeurType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options)
    {
        $builder
            ->add('version')
            ->add('created')
            ->add('nomEditeur')
            ->add('siteWeb')
            ->add('initiale')
        ;
    }

    public function setDefaultOptions(OptionsResolverInterface $resolver)
    {
        $resolver->setDefaults(array(
            'data_class' => 'BDTheque\DataModelBundle\Entity\Editeur'
        ));
    }

    public function getName()
    {
        return 'bdtheque_datamodelbundle_editeurtype';
    }
}
