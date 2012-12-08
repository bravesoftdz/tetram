<?php

namespace BDTheque\DataModelBundle\Form\Type;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolverInterface;

class SerieType extends AbstractType {

    public function buildForm(FormBuilderInterface $builder, array $options) {
        $builder
                ->add('version')
                ->add('created')
                ->add('titre', 'text', array('required' => true))
                ->add('terminee')
                ->add('sujet')
                ->add('notes')
                ->add('siteWeb')
                ->add('suivreManquants')
                ->add('complete')
                ->add('suivreSorties')
                ->add('couleur')
                ->add('nbAlbums')
                ->add('vo')
                ->add('notation')
                ->add('initiale')
                ->add('collection', 'collection_selector')
                ->add('genres')
                ->add('editeur', 'editeur_selector')
        ;
    }

    public function setDefaultOptions(OptionsResolverInterface $resolver) {
        $resolver->setDefaults(array(
            'data_class' => 'BDTheque\DataModelBundle\Entity\Serie'
        ));
    }

    public function getName() {
        return 'bdtheque_datamodelbundle_serietype';
    }

}
