<?php

namespace BDTheque\DataModelBundle\Repository;

use BDTheque\DataModelBundle\Repository\BaseEntityRepository;

class BaseEntityItemRepository extends BaseEntityRepository {

    public function getInitiales() {
        $query = $this->_em->createQuery('select e.initiale, count(e.id) _count from ' . $this->getClassName() . ' e group by e.initiale');
        return $query->getArrayResult();
    }

    public function getByInitiales($initiale) {
        $query = $this->_em->createQuery('select e.id, e from ' . $this->getClassName() . ' e where e.initiale = ?1')->setParameter(1, $initiale);
        return $query->getArrayResult();
    }

}

?>
