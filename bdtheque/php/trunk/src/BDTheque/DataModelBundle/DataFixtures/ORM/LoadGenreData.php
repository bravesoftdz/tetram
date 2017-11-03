<?php

namespace BDTheque\DataModelBundle\DataFixtures\ORM;

use \Doctrine\Common\DataFixtures\AbstractFixture;
use \Doctrine\Common\DataFixtures\OrderedFixtureInterface;
use \Doctrine\Common\Persistence\ObjectManager;
use \BDTheque\DataModelBundle\Entity\Genre;

/**
 * Description of LoadGenreData
 *
 * @author Thierry
 */
class LoadGenreData extends AbstractFixture implements OrderedFixtureInterface {

    public function getOrder() {
        return FixtureOrder::GENRE;
    }

    public function load(ObjectManager $manager) {
        $genre = new Genre();
        $genre->setGenre("Action");
        $manager->persist($genre);
        $this->setReference("GENRE-" . $genre->getGenre(), $genre);

        $genre = new Genre();
        $genre->setGenre("Aventures");
        $manager->persist($genre);
        $this->setReference("GENRE-" . $genre->getGenre(), $genre);

        $genre = new Genre();
        $genre->setGenre("Humour");
        $manager->persist($genre);
        $this->setReference("GENRE-" . $genre->getGenre(), $genre);

        $genre = new Genre();
        $genre->setGenre("Héroique fantaisie");
        $manager->persist($genre);
        $this->setReference("GENRE-" . $genre->getGenre(), $genre);

        $genre = new Genre();
        $genre->setGenre("Mythologie");
        $manager->persist($genre);
        $this->setReference("GENRE-" . $genre->getGenre(), $genre);

        $genre = new Genre();
        $genre->setGenre("Enfant");
        $manager->persist($genre);
        $this->setReference("GENRE-" . $genre->getGenre(), $genre);

        $genre = new Genre();
        $genre->setGenre("Fantastique");
        $manager->persist($genre);
        $this->setReference("GENRE-" . $genre->getGenre(), $genre);

        $genre = new Genre();
        $genre->setGenre("Hommage");
        $manager->persist($genre);
        $this->setReference("GENRE-" . $genre->getGenre(), $genre);

        $genre = new Genre();
        $genre->setGenre("Guerre");
        $manager->persist($genre);
        $this->setReference("GENRE-" . $genre->getGenre(), $genre);

        $genre = new Genre();
        $genre->setGenre("Horreur");
        $manager->persist($genre);
        $this->setReference("GENRE-" . $genre->getGenre(), $genre);

        $genre = new Genre();
        $genre->setGenre("Policier");
        $manager->persist($genre);
        $this->setReference("GENRE-" . $genre->getGenre(), $genre);

        $genre = new Genre();
        $genre->setGenre("Science-Fiction");
        $manager->persist($genre);
        $this->setReference("GENRE-" . $genre->getGenre(), $genre);

        $genre = new Genre();
        $genre->setGenre("Western");
        $manager->persist($genre);
        $this->setReference("GENRE-" . $genre->getGenre(), $genre);

        $genre = new Genre();
        $genre->setGenre("Anticipation");
        $manager->persist($genre);
        $this->setReference("GENRE-" . $genre->getGenre(), $genre);

        $genre = new Genre();
        $genre->setGenre("Animation");
        $manager->persist($genre);
        $this->setReference("GENRE-" . $genre->getGenre(), $genre);

        $genre = new Genre();
        $genre->setGenre("Manga");
        $manager->persist($genre);
        $this->setReference("GENRE-" . $genre->getGenre(), $genre);

        $genre = new Genre();
        $genre->setGenre("Comédie");
        $manager->persist($genre);
        $this->setReference("GENRE-" . $genre->getGenre(), $genre);

        $genre = new Genre();
        $genre->setGenre("Comédie dramatique");
        $manager->persist($genre);
        $this->setReference("GENRE-" . $genre->getGenre(), $genre);

        $genre = new Genre();
        $genre->setGenre("Comédie musicale");
        $manager->persist($genre);
        $this->setReference("GENRE-" . $genre->getGenre(), $genre);

        $genre = new Genre();
        $genre->setGenre("Road movie");
        $manager->persist($genre);
        $this->setReference("GENRE-" . $genre->getGenre(), $genre);

        $genre = new Genre();
        $genre->setGenre("Historique");
        $manager->persist($genre);
        $this->setReference("GENRE-" . $genre->getGenre(), $genre);

        $genre = new Genre();
        $genre->setGenre("Thriller");
        $manager->persist($genre);
        $this->setReference("GENRE-" . $genre->getGenre(), $genre);

        $genre = new Genre();
        $genre->setGenre("Espionnage");
        $manager->persist($genre);
        $this->setReference("GENRE-" . $genre->getGenre(), $genre);

        $genre = new Genre();
        $genre->setGenre("Esotérisme");
        $manager->persist($genre);
        $this->setReference("GENRE-" . $genre->getGenre(), $genre);

        $genre = new Genre();
        $genre->setGenre("Blog");
        $manager->persist($genre);
        $this->setReference("GENRE-" . $genre->getGenre(), $genre);

        $genre = new Genre();
        $genre->setGenre("Erotique");
        $manager->persist($genre);
        $this->setReference("GENRE-" . $genre->getGenre(), $genre);

        $genre = new Genre();
        $genre->setGenre("Sport");
        $manager->persist($genre);
        $this->setReference("GENRE-" . $genre->getGenre(), $genre);

        $manager->flush();
    }

}

?>
