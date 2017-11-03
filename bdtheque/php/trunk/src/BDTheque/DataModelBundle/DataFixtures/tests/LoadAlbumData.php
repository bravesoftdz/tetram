<?php

namespace BDTheque\DataModelBundle\DataFixtures\ORM;

use \Doctrine\Common\DataFixtures\AbstractFixture;
use \Doctrine\Common\DataFixtures\OrderedFixtureInterface;
use \Doctrine\Common\Persistence\ObjectManager;
use \BDTheque\DataModelBundle\Entity\Album;

/**
 * Description of LoadAlbumData
 *
 * @author Thierry
 */
class LoadAlbumData extends AbstractFixture implements OrderedFixtureInterface {

    public function getOrder() {
        return FixtureOrder::ALBUM;
    }

    public function load(ObjectManager $manager) {

        $manager->flush();
    }

}

?>
