<?php

namespace \Doctrine\DBAL\Platforms;

class FBPlatform extends AbstractPlatform {

    /**
     * {@inheritDoc}
     */
    public function initializeDoctrineTypeMappings() {
        $this->doctrineTypeMapping = array(
            'smallint' => 'smallint',
            'bigint' => 'bigint',
            'integer' => 'integer',
            'time' => 'time',
            'date' => 'date',
            'varchar' => 'string',
            'char' => 'string',
            'blob' => 'text',
            'numeric' => 'decimal',
            'double' => 'float',
            'timestamp' => 'datetime',
        );
    }

    /**
     * {@inheritDoc}
     */
    public function getDateAddDaysExpression($date, $days) {
        return 'CAST(' . $date . ' AS TIMESTAMP) + ' . $days;
    }

    /**
     * {@inheritDoc}
     */
    public function getDateSubDaysExpression($date, $days) {
        return 'CAST(' . $date . ' AS TIMESTAMP) - ' . $days;
    }

    /**
     * {@inheritDoc}
     */
    public function getColumnCharsetDeclarationSQL($charset) {
        return 'CHARSET ' . $charset;
    }

    /**
     * {@inheritDoc}
     */
    public function getColumnCollationDeclarationSQL($collation) {
        return 'COLLATE ' . $collation;
    }

    /**
     * {@inheritDoc}
     */
    public function getMaxIdentifierLength() {
        return 25;
    }

    /**
     * {@inheritDoc}
     */
    public function getTruncateTableSQL($tableName, $cascade = false) {
        return 'DELETE FROM ' . $tableName;
    }

    /**
     * {@inheritDoc}
     */
    public function getDummySelectSQL() {
        return 'SELECT 1 FROM RDB$DATABASE';
    }

    /**
     * {@inheritDoc}
     */
    public function getListTableColumnsSQL($table, $database = null) {
        return 'select ' .
                '  FLD.RDB$FIELD_TYPE' .
                ', FLD.RDB$FIELD_SCALE' .
                ', FLD.RDB$FIELD_LENGTH' .
                ', FLD.RDB$FIELD_PRECISION' .
                ', FLD.RDB$CHARACTER_SET_ID' . // CHARACTER SET
                ', RFR.RDB$COLLATION_ID' .
                ', COL.RDB$COLLATION_NAME' . // COLLATE
                ', FLD.RDB$FIELD_SUB_TYPE' .
                ', RFR.RDB$DEFAULT_SOURCE' . // DEFAULT
                ', RFR.RDB$FIELD_NAME' .
                ', FLD.RDB$SEGMENT_LENGTH' .
                ', FLD.RDB$SYSTEM_FLAG' .
                ', RFR.RDB$NULL_FLAG' . // NULLABLE
                ', FLD.RDB$VALIDATION_SOURCE' . // CHECK
                ', FLD.RDB$DIMENSIONS' .
                ', RFR.RDB$FIELD_SOURCE' .
                ', FLD.RDB$COMPUTED_SOURCE' . // COMPUTED BY
                ', RDB$VALIDATION_SOURCE ' .
                'from ' .
                '  RDB$RELATIONS REL ' .
                'join RDB$RELATION_FIELDS RFR on (RFR.RDB$RELATION_NAME = REL.RDB$RELATION_NAME) ' .
                'join RDB$FIELDS FLD on (RFR.RDB$FIELD_SOURCE = FLD.RDB$FIELD_NAME) ' .
                'left outer join RDB$COLLATIONS COL on (COL.RDB$COLLATION_ID = RFR.RDB$COLLATION_ID and COL.RDB$CHARACTER_SET_ID = FLD.RDB$CHARACTER_SET_ID) ' .
                'where ' .
                '  (REL.RDB$RELATION_NAME = "' . $table . '") ' .
                'order by ' .
                '  RFR.RDB$FIELD_POSITION, RFR.RDB$FIELD_NAME';
    }

    /**
     * {@inheritDoc}
     */
    public function getListTablesSQL() {
        return 'select ' .
                '  REL.RDB$RELATION_NAME ' .
                'from ' .
                '  RDB$RELATIONS REL ' .
                'where ' .
                '  (REL.RDB$SYSTEM_FLAG <> 1 or REL.RDB$SYSTEM_FLAG is null) and ' .
                '  (NOT REL.RDB$FLAGS is null) and ' .
                '  (REL.RDB$VIEW_BLR is null) and ' .
                '  (REL.RDB$SECURITY_CLASS starting with \'SQL$\') ' .
                'order by ' .
                '  REL.RDB$RELATION_NAME';
    }

}

?>
