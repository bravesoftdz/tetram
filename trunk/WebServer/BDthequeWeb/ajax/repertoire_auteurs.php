<?
require_once '../routines.php';
?>

<?
switch ($_REQUEST['action'])
{
	case 'treenode':
		$ref = $_REQUEST['ref'];
		if ($ref == '-1') $ref = '';
		$ref = format_string_null($ref, true);	
		$sql = 'select id_personne, nompersonne from /*DB_PREFIX*/personnes where initialenompersonne '.$ref.' order by uppernompersonne';
		$rs = load_sql($sql);

		while ($row = mysql_fetch_object($rs)) 
			echo AjaxLink('personne', $row->id_personne, format_titre($row->nompersonne), 'auteur').'<br/>';
		break;
	default:
		$sql = 'select initialenompersonne, count(id_personne) from  /*DB_PREFIX*/personnes group by initialenompersonne';
		prepare_sql($sql);
		$rs = mysql_query($sql) or die(mysql_error());
		$c = 0;
		while ($row = mysql_fetch_array($rs, MYSQL_NUM)) 
		{
			$display = $row[0]=='-1' ? '&lt;Inconnu&gt;':format_titre($row[0]);
			$ref = $row[0];
			$count = $row[1];
?>
<div class=treeNode <?echo $c++ % 2?' style="background-color: #e5e5ff;"':''?>>
    <a href='#' onclick='return treeLoad("treeChild<? echo $ref ?>", "repertoire_auteurs.php?action=treenode&ref=<? echo urlencode($ref) ?>", this)'><? echo _out($display) ?></a>&nbsp;&nbsp;&nbsp;- (<?echo $count?>)
</div>
<div class=treeChildNode id=treeChild<? echo $ref ?> style="display:"></div>
<? 
		} 
}
?>
