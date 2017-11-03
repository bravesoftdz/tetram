<?php

namespace Doctrine\DBAL\Schema;

use Doctrine\DBAL\Driver\Firebird\FBConstants;
use Doctrine\DBAL\FBException;

class FBSchemaManager extends AbstractSchemaManager {

    protected function _getPortableTableColumnDefinition($tableColumn) {
        $scale = abs($tableColumn[1]);
        $length = $tableColumn[2];
        $precision = $tableColumn[3];
        if ($scale > 0) {
            $dbType = 'numeric';
            if ($precision == 0) {
                switch ($tableColumn[0]) {
                    case FBConstants::blr_short:
                        $precision = 4;
                        break;
                    case FBConstants::blr_long:
                        $precision = 7;
                        break;
                    case FBConstants::blr_int64:
                    case FBConstants::blr_quad:
                    case FBConstants::blr_double:
                        $precision = 15;
                        break;
                    default:
                        throw FBException::notExcpected();
                }
            }
        } else {
            switch ($tableColumn[0]) {
                case FBConstants::blr_text:
                case FBConstants::blr_text2:
                    $dbType = 'char';
                    break;
                case FBConstants::blr_varying:
                case FBConstants::blr_varying2:
                    $dbType = 'varchar';
                    break;
                case FBConstants::blr_cstring:
                case FBConstants::blr_cstring2:
                    $dbType = 'cstring';
                    break;
                case FBConstants::blr_short:
                    $dbType = 'smallint';
                    break;
                case FBConstants::blr_long:
                    $dbType = 'integer';
                    break;
                case FBConstants::blr_quad:
                    $dbType = 'quad';
                    break;
                case FBConstants::blr_float:
                case FBConstants::blr_d_float:
                    $dbType = 'float';
                    break;
                case FBConstants::blr_double:
                    $dbType = 'double';
                    break;
                case FBConstants::blr_timestamp:
                    $dbType = 'timestamp';
                    break;
                case FBConstants::blr_blob:
                    $dbType = 'blob';
                    break;
                case FBConstants::blr_blob_id:
                    $dbType = 'blobid';
                    break;
                case FBConstants::blr_sql_date:
                    $dbType = 'date';
                    break;
                case FBConstants::blr_sql_time:
                    $dbType = 'time';
                    break;
                case FBConstants::blr_int64:
                    $dbType = 'int64';
                    break;
                // {$IFDEF IB7_UP}
                case FBConstants::blr_boolean_dtype:
                    $dbType = 'boolean';
                    break;
                // {$ENDIF IB7_UP}
                default:
                    break;
            }
        }
        /*
         *  if (FFieldType in [uftChar, uftVarchar, uftCstring]) and
         *    not QField.Fields.IsNull[4] then
         *    begin
         *      FindCharset(QField.Fields.AsSmallint[4], FCharSet, FBytesPerCharacter);
         *      if (FCharSet = string(CharacterSetStr[DefaultCharset])) then
         *        FCharSet := '';
         *      if QField.Fields.IsNull[5] or (QField.Fields.AsInteger[5] = 0) then
         *        FCollation := ''
         *      else
         *        FCollation := Trim(QField.Fields.AsString[6])
         *    end
         *  else
         *    FBytesPerCharacter := 1;
         */
 
         /*
         *  if not QField.Fields.IsNull[8] then
         *  begin
         *    QField.ReadBlob(8, FDefaultValue);
         *    FDefaultValue := Trim(FDefaultValue);
         *    if FDefaultValue <> '' then
         *      FDefaultValue := Copy(FDefaultValue, 9, System.Length(FDefaultValue) - 8);
         *  end
         *  else
         *    FDefaultValue := '';
         *
         */

        $type = $this->_platform->getDoctrineTypeMapping($dbType);

        $options = array(
            'length' => $length,
            'default' => $tableColumn[8],
            'notnull' => (bool) ($tableColumn[12] == 1),
            'scale' => $scale,
            'precision' => $precision,
            'platformOptions' => array(
                'sub_type' => $tableColumn[7]
            ),
        );
        
        return new Column($tableColumn[9], \Doctrine\DBAL\Types\Type::getType($type), $options);
    }

}

?>
