<?php

namespace BDTheque\DataModelBundle\DataFixtures\ORM;

use \Doctrine\Common\DataFixtures\AbstractFixture;
use \Doctrine\Common\DataFixtures\OrderedFixtureInterface;
use \Doctrine\Common\Persistence\ObjectManager;
use \BDTheque\DataModelBundle\Entity\Collection;

/**
 * Description of LoadCollectionData
 *
 * @author Thierry
 */
class LoadCollectionData extends AbstractFixture implements OrderedFixtureInterface {

    public function getOrder() {
        return FixtureOrder::COLLECTION;
    }

    public function load(ObjectManager $manager) {
        $collection = new Collection();
        $collection->setNomCollection("Soleil levant");
        $collection->setEditeur($this->getReference("EDITEUR-Soleil"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Néopolis");
        $collection->setEditeur($this->getReference("EDITEUR-Delcourt"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Génération Dargaud");
        $collection->setEditeur($this->getReference("EDITEUR-Dargaud"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Insomnie");
        $collection->setEditeur($this->getReference("EDITEUR-Delcourt"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Terres de légendes");
        $collection->setEditeur($this->getReference("EDITEUR-Delcourt"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Repérages");
        $collection->setEditeur($this->getReference("EDITEUR-Dupuis"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Trait d'humour");
        $collection->setEditeur($this->getReference("EDITEUR-Niffle"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Signé");
        $collection->setEditeur($this->getReference("EDITEUR-Lombard [Le]"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Polyptyque");
        $collection->setEditeur($this->getReference("EDITEUR-Lombard [Le]"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Grafica");
        $collection->setEditeur($this->getReference("EDITEUR-Glénat"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Tchô ! La collec..");
        $collection->setEditeur($this->getReference("EDITEUR-Glénat"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Bulle noire");
        $collection->setEditeur($this->getReference("EDITEUR-Glénat"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Soleil de nuit");
        $collection->setEditeur($this->getReference("EDITEUR-Soleil"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Start");
        $collection->setEditeur($this->getReference("EDITEUR-Soleil"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Triskel");
        $collection->setEditeur($this->getReference("EDITEUR-Soleil"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Humour libre");
        $collection->setEditeur($this->getReference("EDITEUR-Dupuis"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Anime Comics");
        $collection->setEditeur($this->getReference("EDITEUR-Glénat"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Science-Fiction");
        $collection->setEditeur($this->getReference("EDITEUR-Soleil"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Art cover");
        $collection->setEditeur($this->getReference("EDITEUR-Soleil"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Humour de rire");
        $collection->setEditeur($this->getReference("EDITEUR-Delcourt"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Conquistador");
        $collection->setEditeur($this->getReference("EDITEUR-Delcourt"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Fictions");
        $collection->setEditeur($this->getReference("EDITEUR-Dargaud"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Akira");
        $collection->setEditeur($this->getReference("EDITEUR-Glénat"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Grand angle");
        $collection->setEditeur($this->getReference("EDITEUR-Bamboo"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Mondes futurs");
        $collection->setEditeur($this->getReference("EDITEUR-Soleil"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Celtic");
        $collection->setEditeur($this->getReference("EDITEUR-Soleil"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Génération Comics");
        $collection->setEditeur($this->getReference("EDITEUR-Panini"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Fantastique");
        $collection->setEditeur($this->getReference("EDITEUR-Vents d'Ouest"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Long courrier");
        $collection->setEditeur($this->getReference("EDITEUR-Dargaud"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("2B");
        $collection->setEditeur($this->getReference("EDITEUR-Soleil"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Autres mondes");
        $collection->setEditeur($this->getReference("EDITEUR-Soleil"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Manga Poche");
        $collection->setEditeur($this->getReference("EDITEUR-Glénat"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Tsuki poche");
        $collection->setEditeur($this->getReference("EDITEUR-Tonkam"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Machination");
        $collection->setEditeur($this->getReference("EDITEUR-Delcourt"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Empreinte(s)");
        $collection->setEditeur($this->getReference("EDITEUR-Dupuis"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Soleil Celtic");
        $collection->setEditeur($this->getReference("EDITEUR-Soleil"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Manga");
        $collection->setEditeur($this->getReference("EDITEUR-Delcourt"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Gags de Fanfoué [Les]");
        $collection->setEditeur($this->getReference("EDITEUR-Editions des Pnottas"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Univers d'auteurs");
        $collection->setEditeur($this->getReference("EDITEUR-Dargaud"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Big Kana");
        $collection->setEditeur($this->getReference("EDITEUR-Kana"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Poisson pilote");
        $collection->setEditeur($this->getReference("EDITEUR-Dargaud"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Akata");
        $collection->setEditeur($this->getReference("EDITEUR-Delcourt"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Passages");
        $collection->setEditeur($this->getReference("EDITEUR-Soleil"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Anniversaire");
        $collection->setEditeur($this->getReference("EDITEUR-Editions des Pnottas"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Humour");
        $collection->setEditeur($this->getReference("EDITEUR-Bamboo"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Quadrant solaire");
        $collection->setEditeur($this->getReference("EDITEUR-Soleil"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Sortilèges");
        $collection->setEditeur($this->getReference("EDITEUR-Clair de lune"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Sketchbook");
        $collection->setEditeur($this->getReference("EDITEUR-Comix Buro"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Shônen");
        $collection->setEditeur($this->getReference("EDITEUR-Glénat"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Shônen");
        $collection->setEditeur($this->getReference("EDITEUR-Kurokawa"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Shônen");
        $collection->setEditeur($this->getReference("EDITEUR-Pika Edition"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Seinen");
        $collection->setEditeur($this->getReference("EDITEUR-Glénat"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Humour");
        $collection->setEditeur($this->getReference("EDITEUR-Vents d'Ouest"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Fluide glamour");
        $collection->setEditeur($this->getReference("EDITEUR-Fluide Glacial"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Adulte");
        $collection->setEditeur($this->getReference("EDITEUR-Drugstore"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Univers d'auteurs");
        $collection->setEditeur($this->getReference("EDITEUR-Casterman"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Jeunesse");
        $collection->setEditeur($this->getReference("EDITEUR-Delcourt"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Fantastique et Science-Fiction");
        $collection->setEditeur($this->getReference("EDITEUR-Drugstore"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $collection = new Collection();
        $collection->setNomCollection("Grand public");
        $collection->setEditeur($this->getReference("EDITEUR-Dupuis"));
        $manager->persist($collection);
        $this->setReference("COLLECTION-" . $collection->getEditeur()->getNomEditeur() . "-" . $collection->getNomCollection(), $collection);

        $manager->flush();
    }

}

?>
