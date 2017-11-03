<?php

namespace BDTheque\DataModelBundle\DataFixtures\ORM;

use \Doctrine\Common\DataFixtures\AbstractFixture;
use \Doctrine\Common\DataFixtures\OrderedFixtureInterface;
use \Doctrine\Common\Persistence\ObjectManager;
use \BDTheque\DataModelBundle\Entity\Editeur;

/**
 * Description of LoadEditeurData
 *
 * @author Thierry
 */
class LoadEditeurData extends AbstractFixture implements OrderedFixtureInterface {

    public function getOrder() {
        return FixtureOrder::EDITEUR;
    }

    public function load(ObjectManager $manager) {
        $editeur = new Editeur();
        $editeur->setNomEditeur("Soleil");
        $editeur->setSiteWeb("http://www.soleilprod.com");
        $manager->persist($editeur);
        $this->setReference('EDITEUR-' . $editeur->getNomEditeur(), $editeur);

        $editeur = new Editeur();
        $editeur->setNomEditeur("Delcourt");
        $editeur->setSiteWeb("http://www.editions-delcourt.fr/");
        $manager->persist($editeur);
        $this->setReference('EDITEUR-' . $editeur->getNomEditeur(), $editeur);

        $editeur = new Editeur();
        $editeur->setNomEditeur("Albert René");
        $manager->persist($editeur);
        $this->setReference('EDITEUR-' . $editeur->getNomEditeur(), $editeur);

        $editeur = new Editeur();
        $editeur->setNomEditeur("Casterman");
        $editeur->setSiteWeb("http://www.casterman.com/");
        $manager->persist($editeur);
        $this->setReference('EDITEUR-' . $editeur->getNomEditeur(), $editeur);

        $editeur = new Editeur();
        $editeur->setNomEditeur("Dargaud");
        $editeur->setSiteWeb("http://www.dargaud.com/");
        $manager->persist($editeur);
        $this->setReference('EDITEUR-' . $editeur->getNomEditeur(), $editeur);

        $editeur = new Editeur();
        $editeur->setNomEditeur("DBD");
        $manager->persist($editeur);
        $this->setReference('EDITEUR-' . $editeur->getNomEditeur(), $editeur);

        $editeur = new Editeur();
        $editeur->setNomEditeur("Dupuis");
        $manager->persist($editeur);
        $this->setReference('EDITEUR-' . $editeur->getNomEditeur(), $editeur);

        $editeur = new Editeur();
        $editeur->setNomEditeur("Vents d'Ouest");
        $editeur->setSiteWeb("http://www.ventsdouest.com/");
        $manager->persist($editeur);
        $this->setReference('EDITEUR-' . $editeur->getNomEditeur(), $editeur);

        $editeur = new Editeur();
        $editeur->setNomEditeur("Nucléa");
        $manager->persist($editeur);
        $this->setReference('EDITEUR-' . $editeur->getNomEditeur(), $editeur);

        $editeur = new Editeur();
        $editeur->setNomEditeur("Niffle");
        $manager->persist($editeur);
        $this->setReference('EDITEUR-' . $editeur->getNomEditeur(), $editeur);

        $editeur = new Editeur();
        $editeur->setNomEditeur("Humanoïdes associés [Les]");
        $manager->persist($editeur);
        $this->setReference('EDITEUR-' . $editeur->getNomEditeur(), $editeur);

        $editeur = new Editeur();
        $editeur->setNomEditeur("Lombard [Le]");
        $manager->persist($editeur);
        $this->setReference('EDITEUR-' . $editeur->getNomEditeur(), $editeur);

        $editeur = new Editeur();
        $editeur->setNomEditeur("Graton");
        $manager->persist($editeur);
        $this->setReference('EDITEUR-' . $editeur->getNomEditeur(), $editeur);

        $editeur = new Editeur();
        $editeur->setNomEditeur("Glénat");
        $manager->persist($editeur);
        $this->setReference('EDITEUR-' . $editeur->getNomEditeur(), $editeur);

        $editeur = new Editeur();
        $editeur->setNomEditeur("Editions USA");
        $manager->persist($editeur);
        $this->setReference('EDITEUR-' . $editeur->getNomEditeur(), $editeur);

        $editeur = new Editeur();
        $editeur->setNomEditeur("Pika Edition");
        $editeur->setSiteWeb("http://www.pika.fr");
        $manager->persist($editeur);
        $this->setReference('EDITEUR-' . $editeur->getNomEditeur(), $editeur);

        $editeur = new Editeur();
        $editeur->setNomEditeur("Bamboo");
        $manager->persist($editeur);
        $this->setReference('EDITEUR-' . $editeur->getNomEditeur(), $editeur);

        $editeur = new Editeur();
        $editeur->setNomEditeur("Panini");
        $editeur->setSiteWeb("http://www.paninicomicsfrance.com/Home.jsp");
        $manager->persist($editeur);
        $this->setReference('EDITEUR-' . $editeur->getNomEditeur(), $editeur);

        $editeur = new Editeur();
        $editeur->setNomEditeur("Editions de la Séguinière");
        $manager->persist($editeur);
        $this->setReference('EDITEUR-' . $editeur->getNomEditeur(), $editeur);

        $editeur = new Editeur();
        $editeur->setNomEditeur("Hachette");
        $manager->persist($editeur);
        $this->setReference('EDITEUR-' . $editeur->getNomEditeur(), $editeur);

        $editeur = new Editeur();
        $editeur->setNomEditeur("Lucky Comics");
        $manager->persist($editeur);
        $this->setReference('EDITEUR-' . $editeur->getNomEditeur(), $editeur);

        $editeur = new Editeur();
        $editeur->setNomEditeur("Kabuto");
        $editeur->setSiteWeb("http://www.editions-kabuto.com");
        $manager->persist($editeur);
        $this->setReference('EDITEUR-' . $editeur->getNomEditeur(), $editeur);

        $editeur = new Editeur();
        $editeur->setNomEditeur("Tonkam");
        $manager->persist($editeur);
        $this->setReference('EDITEUR-' . $editeur->getNomEditeur(), $editeur);

        $editeur = new Editeur();
        $editeur->setNomEditeur("Horizon BD");
        $editeur->setSiteWeb("http://www.horizonbd.com/");
        $manager->persist($editeur);
        $this->setReference('EDITEUR-' . $editeur->getNomEditeur(), $editeur);

        $editeur = new Editeur();
        $editeur->setNomEditeur("Theloma");
        $manager->persist($editeur);
        $this->setReference('EDITEUR-' . $editeur->getNomEditeur(), $editeur);

        $editeur = new Editeur();
        $editeur->setNomEditeur("Editions des Pnottas");
        $manager->persist($editeur);
        $this->setReference('EDITEUR-' . $editeur->getNomEditeur(), $editeur);

        $editeur = new Editeur();
        $editeur->setNomEditeur("Asuka");
        $editeur->setSiteWeb("http://www.asuka.fr/");
        $manager->persist($editeur);
        $this->setReference('EDITEUR-' . $editeur->getNomEditeur(), $editeur);

        $editeur = new Editeur();
        $editeur->setNomEditeur("Kana");
        $editeur->setSiteWeb("http://www.mangakana.com");
        $manager->persist($editeur);
        $this->setReference('EDITEUR-' . $editeur->getNomEditeur(), $editeur);

        $editeur = new Editeur();
        $editeur->setNomEditeur("Kurokawa");
        $editeur->setSiteWeb("http://www.kurokawa.fr");
        $manager->persist($editeur);
        $this->setReference('EDITEUR-' . $editeur->getNomEditeur(), $editeur);

        $editeur = new Editeur();
        $editeur->setNomEditeur("Tokumashoten");
        $manager->persist($editeur);
        $this->setReference('EDITEUR-' . $editeur->getNomEditeur(), $editeur);

        $editeur = new Editeur();
        $editeur->setNomEditeur("Albin Michel");
        $manager->persist($editeur);
        $this->setReference('EDITEUR-' . $editeur->getNomEditeur(), $editeur);

        $editeur = new Editeur();
        $editeur->setNomEditeur("Ankama");
        $editeur->setSiteWeb("http://www.ankama-editions.com");
        $manager->persist($editeur);
        $this->setReference('EDITEUR-' . $editeur->getNomEditeur(), $editeur);

        $editeur = new Editeur();
        $editeur->setNomEditeur("Clair de lune");
        $editeur->setSiteWeb("http://editionsclairdelune.free.fr/");
        $manager->persist($editeur);
        $this->setReference('EDITEUR-' . $editeur->getNomEditeur(), $editeur);

        $editeur = new Editeur();
        $editeur->setNomEditeur("Comix Buro");
        $manager->persist($editeur);
        $this->setReference('EDITEUR-' . $editeur->getNomEditeur(), $editeur);

        $editeur = new Editeur();
        $editeur->setNomEditeur("Fluide Glacial");
        $editeur->setSiteWeb("http://www.fluideglacial.tm.fr/");
        $manager->persist($editeur);
        $this->setReference('EDITEUR-' . $editeur->getNomEditeur(), $editeur);

        $editeur = new Editeur();
        $editeur->setNomEditeur("Drugstore");
        $editeur->setSiteWeb("http://www.drugstorebd.com");
        $manager->persist($editeur);
        $this->setReference('EDITEUR-' . $editeur->getNomEditeur(), $editeur);

        $editeur = new Editeur();
        $editeur->setNomEditeur("Desinge & Hugo & Cie");
        $manager->persist($editeur);
        $this->setReference('EDITEUR-' . $editeur->getNomEditeur(), $editeur);

        $manager->flush();
    }

}

?>
