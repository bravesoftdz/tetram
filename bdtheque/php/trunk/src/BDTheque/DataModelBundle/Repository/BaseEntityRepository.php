<?php

namespace BDTheque\DataModelBundle\Repository;

use Doctrine\ORM\EntityRepository;

abstract class BaseEntityRepository extends EntityRepository {

    public function getInitiales() {
        $query = $this->_em->createQueryBuilder()
                ->select('e.initiale', 'count(e.id)')
                ->from($this->getClassName(), 'e')
                ->groupBy('e.initiale')
                ->getQuery();
        return $query->getArrayResult();
    }

}

?>
