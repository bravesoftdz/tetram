<?php

namespace BDTheque\DataModelBundle\Repository;

use BDTheque\DataModelBundle\Repository\BaseEntityItemRepository;

class SerieRepository extends BaseEntityItemRepository {

    function listAll() {
        $query = $this->_em->createQueryBuilder()
                ->select('s', 'e', 'c')
                ->from('BDThequeDataModelBundle:Serie', 's')
                ->leftJoin('s.editeur', 'e')
                ->leftJoin('s.collection', 'c')
                ->orderBy('s.titre')
                ->addOrderBy('e.nomEditeur')
                ->addOrderBy('c.nomCollection')
                ->getQuery();

        return $query->getResult();
    }

}

?>