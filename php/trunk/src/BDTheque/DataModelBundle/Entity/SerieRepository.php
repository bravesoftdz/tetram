<?php

namespace BDTheque\DataModelBundle\Entity;

use Doctrine\ORM\EntityRepository;

class SerieRepository extends EntityRepository {

    public function getInitiales() {
        return $this->getEntityManager()
                        ->createQuery('select distinct initiale from Serie order by initiale')
                        ->getArrayResult();
    }

}
