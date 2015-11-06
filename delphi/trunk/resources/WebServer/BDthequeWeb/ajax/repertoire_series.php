<?php
require_once '../routines.php';
?>

<?php
if (!isset($_REQUEST['action'])) $_REQUEST['action'] = '';

switch ($_REQUEST['action'])
{
	case 'treenode':
		$ref = $_REQUEST['ref'];
		if ($ref == '-1') $ref = '';
		$ref = format_string_null($ref, true);		
		$sql = 'select id_serie, titreserie, s.id_editeur, nomediteur, s.id_collection, nomcollection from /*DB_PREFIX*/series s left join /*DB_PREFIX*/editeurs e on s.id_editeur = e.id_editeur left join /*DB_PREFIX*/collections c on s.id_collection = c.id_collection where initialetitreserie '.$ref.' order by uppertitreserie, uppernomediteur, uppernomcollection';
		$rs = load_sql($sql);

		while ($row = $rs->fetch_object()) 
			echo AjaxLink('serie', $row->id_serie, display_titreserie($row, false, true), 'série').'<br/>';
		$rs->free();
		break;
	default:
		$sql = 'select initialetitreserie, count(id_serie) from /*DB_PREFIX*/series group by initialetitreserie';
		prepare_sql($sql);
		$rs = $db_link->query($sql) or die($db_link->error);
		$c = 0;
		while ($row = $rs->fetch_array(MYSQL_NUM)) 
		{
			$display = $row[0]=='-1' ? '&lt;Inconnu&gt;':format_titre($row[0]);
			$ref = $row[0];
			$count = $row[1];
?>
<div class=treeNode <?php echo $c++ % 2?' style="background-color: #e5e5ff;"':''?>>
    <a href='#' onclick='return treeLoad("treeChild<?php echo $ref ?>", "repertoire_series.php?action=treenode&ref=<?php echo urlencode($ref) ?>", this)'><?php echo _out($display) ?></a>&nbsp;&nbsp;&nbsp;- (<?php echo $count?>)
</div>
<div class=treeChildNode id=treeChild<?php echo $ref ?> style="display:"></div>
<?php 
		}
		$rs->free();
}
?>
