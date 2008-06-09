<?
require_once 'db.php';
?>
<P>
    <hr align=left width=50>
<?
$end_time = gettimeofday(false);
$end_time = (float) ($end_time['sec'] + $end_time['usec'] / 1000000.0);
$exec_time = $end_time - $start_time;
?>    
    <font size=-2>Page générée en <?echo sprintf('%.3f', $exec_time)?> secondes avec <?echo $nb_requetes_sql?> requête(s) sql.</font>
