<?php

namespace BDTheque\DataModelBundle\Form;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolverInterface;

class AlbumType extends AbstractType {

    public function buildForm(FormBuilderInterface $builder, array $options) {
        $builder
                ->add('version')
                ->add('created')
                ->add('titre')
                ->add('sujet')
                ->add('horsSerie')
                ->add('moisParution')
                ->add('tomeFin')
                ->add('notes')
                ->add('anneeParution')
                ->add('integrale')
                ->add('tomeDebut')
                ->add('tome')
                ->add('complet')
                ->add('notation')
                ->add('initiale')
                ->add('serie')
        ;
    }

    public function setDefaultOptions(OptionsResolverInterface $resolver) {
        $resolver->setDefaults(array(
            'data_class' => 'BDTheque\DataModelBundle\Entity\Album'
        ));
    }

    public function getName() {
        return 'bdtheque_datamodelbundle_albumtype';
    }

}
