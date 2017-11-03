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
		$sql = 'select id_personne, nompersonne from /*DB_PREFIX*/personnes where initialenompersonne '.$ref.' order by uppernompersonne';
		$rs = load_sql($sql);

		while ($row = $rs->fetch_object()) 
			echo AjaxLink('personne', $row->id_personne, format_titre($row->nompersonne), 'auteur').'<br/>';
		$rs->free();
		break;
	default:
		$sql = 'select initialenompersonne, count(id_personne) from  /*DB_PREFIX*/personnes group by initialenompersonne';
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
    <a href='#' onclick='return treeLoad("treeChild<?php echo $ref ?>", "repertoire_auteurs.php?action=treenode&ref=<?php echo urlencode($ref) ?>", this)'><?php echo _out($display) ?></a>&nbsp;&nbsp;&nbsp;- (<?php echo $count?>)
</div>
<div class=treeChildNode id=treeChild<?php echo $ref ?> style="display:"></div>
<?php 
		} 
		$rs->free();
}
?>
