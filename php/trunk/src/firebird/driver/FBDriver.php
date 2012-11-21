<?php

namespace Doctrine\DBAL\Driver\Firebird;

use Doctrine\DBAL\Driver;
use Doctrine\DBAL\Connection;

/**
 * Firebird Driver
 */
class FBDriver implements Driver {

    /**
     * Attempts to create a connection with the database.
     *
     * @param array $params All connection parameters passed by the user.
     * @param string $username The username to use when connecting.
     * @param string $password The password to use when connecting.
     * @param array $driverOptions The driver options to use when connecting.
     * @return \Doctrine\DBAL\Driver\Connection The database connection.
     */
    public function connect(array $params, $username = null, $password = null, array $driverOptions = array()) {
        $conn = new \Doctrine\DBAL\Driver\PDOConnection(
                        $this->_constructPdoDsn($params),
                        $username,
                        $password,
                        $driverOptions
        );
        return $conn;
    }

    /**
     * Constructs the Firebird PDO DSN.
     *
     * @return string  The DSN.
     */
    private function _constructPdoDsn(array $params) {
        $dsn = 'firebird:dbname=';
        if (isset($params['host'])) {
            $dsn .= $params['host'];
            if (isset($params['port'])) {
                $dsn .= '/' . $params['port'];
            }
            $dsn .= ':';
        }
        if (isset($params['dbname'])) {
            $dsn .= $params['dbname'] . ';';
        }

        return $dsn;
    }

    /**
     * Gets the DatabasePlatform instance that provides all the metadata about
     * the platform this driver connects to.
     *
     * @return \Doctrine\DBAL\Platforms\AbstractPlatform The database platform.
     */
    public function getDatabasePlatform() {
        return new \Doctrine\DBAL\Platforms\FBPlatform;
    }

    /**
     * Gets the SchemaManager that can be used to inspect and change the underlying
     * database schema of the platform this driver connects to.
     *
     * @param  \Doctrine\DBAL\Connection $conn
     * @return \Doctrine\DBAL\Schema\FBSchemaManager
     */
    public function getSchemaManager(Connection $conn) {
        return new \Doctrine\DBAL\Schema\FBSchemaManager($conn);
    }

    /**
     * Gets the name of the driver.
     *
     * @return string The name of the driver.
     */
    public function getName() {
        return 'pdo_firebird';
    }

    /**
     * Get the name of the database connected to for this driver.
     *
     * @param  \Doctrine\DBAL\Connection $conn
     * @return string $database
     */
    public function getDatabase(\Doctrine\DBAL\Connection $conn) {
        $params = $conn->getParams();
        return $params['dbname'];
    }

}
