<?php

namespace BDTheque\DataModelBundle\Repository;

use BDTheque\DataModelBundle\Repository\BaseEntityRepository;

abstract class BaseEntityItemRepository extends BaseEntityRepository {

    public function getInitiales() {
        $query = $this->_em->createQuery('select e.initiale, count(e.id) _count from ' . $this->getClassName() . ' e group by e.initiale');
        return $query->getArrayResult();
    }

    public function getByInitiales($initiale) {
        $query = $this->_em->createQueryBuilder()
                ->select('e.id', 'e obj')
                ->from($this->getEntityName(), 'e')
                ->where('e.initiale = ?1')
                ->getQuery()
                ->setParameter(1, $initiale);

        return $query->getResult();
    }

}

?>
