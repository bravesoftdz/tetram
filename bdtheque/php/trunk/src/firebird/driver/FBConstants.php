<?php

namespace Doctrine\DBAL\Driver\Firebird;

class FBConstants {
    /*     * *****************
     * Blr definitions *
     * ***************** */

    const blr_text = 14;
    const blr_text2 = 15; // added in 3.2 JPN
    const blr_short = 7;
    const blr_long = 8;
    const blr_quad = 9;
    const blr_float = 10;
    const blr_double = 27;
    const blr_d_float = 11;
    const blr_timestamp = 35;
    const blr_varying = 37;
    const blr_varying2 = 38; // added in 3.2 JPN
    const blr_blob = 261;
    const blr_cstring = 40;
    const blr_cstring2 = 41; // added in 3.2 JPN
    const blr_blob_id = 45; // added from gds.h
    const blr_sql_date = 12;
    const blr_sql_time = 13;
    const blr_int64 = 16;
// {$IFDEF FB20_UP}
    const blr_blob2 = 17;

// {$ENDIF}
}

?>
