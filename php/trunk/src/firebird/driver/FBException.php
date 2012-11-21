<?php

namespace Doctrine\DBAL;

class FBException extends DBALException {
    public static function notExcpected(){
        return new self('Unexpected error.');
    }
}
?>
