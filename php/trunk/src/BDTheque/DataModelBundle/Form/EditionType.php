<?php

namespace BDTheque\DataModelBundle\Form;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolverInterface;

class EditionType extends AbstractType {

    public function buildForm(FormBuilderInterface $builder, array $options) {
        $builder
                ->add('version')
                ->add('created')
                ->add('stock')
                ->add('prix')
                ->add('anneeCote')
                ->add('isbn')
                ->add('gratuit')
                ->add('prete')
                ->add('nombreDePages')
                ->add('numeroPerso')
                ->add('notes')
                ->add('anneeEdition')
                ->add('dedicace')
                ->add('couleur')
                ->add('prixCote')
                ->add('dateAchat')
                ->add('offert')
                ->add('vo')
                ->add('collection')
                ->add('editeur')
                ->add('album')
        ;
    }

    public function setDefaultOptions(OptionsResolverInterface $resolver) {
        $resolver->setDefaults(array(
            'data_class' => 'BDTheque\DataModelBundle\Entity\Edition'
        ));
    }

    public function getName() {
        return 'bdtheque_datamodelbundle_editiontype';
    }

}
