<?php
include_once('../routines.php');
?>
<?php
switch ($_REQUEST['GroupBy'])
{
	case 1: // par année
		$sql = '(select -1 as anneeparution, count(id_album) from /*DB_PREFIX*/vw_liste_albums where anneeparution is null group by anneeparution) union (select anneeparution, count(id_album) from /*DB_PREFIX*/vw_liste_albums where anneeparution is not null group by anneeparution)';
		break;
	case 2: // par collection
		$sql = '(select -1, -1, count(id_album) from /*DB_PREFIX*/vw_liste_collections_albums where id_collection is null group by uppernomcollection, nomcollection, id_collection) union (select nomcollection, id_collection, count(id_album) from /*DB_PREFIX*/vw_liste_collections_albums where id_collection is not null group by uppernomcollection, nomcollection, id_collection)';
		break;
	case 3: // par editeur
		$sql = '(select -1, -1, count(id_album) from /*DB_PREFIX*/vw_liste_editeurs_albums where id_editeur is null group by uppernomediteur, nomediteur, id_editeur) union (select nomediteur, id_editeur, count(id_album) from /*DB_PREFIX*/vw_liste_editeurs_albums where id_editeur is not null group by uppernomediteur, nomediteur, id_editeur)';
		break;
	case 4: // par genre
		$sql = '(select -1, -1, count(id_album) from /*DB_PREFIX*/vw_liste_genres_albums where id_genre is null group by uppergenre, genre, id_genre) union (select genre, id_genre, count(id_album) from /*DB_PREFIX*/vw_liste_genres_albums where id_genre is not null group by uppergenre, genre, id_genre)';
		break;
	case 5: // par série
		$sql = '(select -1 as titreserie, -1 as id_serie, count(id_album) from /*DB_PREFIX*/vw_liste_albums where titreserie is null group by uppertitreserie, titreserie, id_serie) union (select titreserie, id_serie, count(id_album) from /*DB_PREFIX*/vw_liste_albums where titreserie is not null group by uppertitreserie, titreserie, id_serie)';
		break;
	case 0:
	default: // par titre
		$sql = 'select coalesce(a.initialetitrealbum, s.initialetitreserie), count(a.id_album) from /*DB_PREFIX*/albums a left join /*DB_PREFIX*/series s on a.id_serie = s.id_serie group by 1';
}
prepare_sql($sql);
$rs = mysql_query($sql) or die(mysql_error());
$c = 0;
while ($row = mysql_fetch_array($rs, MYSQL_NUM)) 
{
	$display = $row[0]=='-1' ? '&lt;Inconnu&gt;':format_titre($row[0]);
	if (mysql_num_fields($rs) == 2) 
	{
		$ref = $row[0];
		$count = $row[1];
	}
	else
	{
		$ref = $row[1];
		$count = $row[2];
	}
?>
<div class=treeNode <?php echo $c++ % 2?' style="background-color: #e5e5ff;"':''?>>
    <a href='#' onclick='return treeLoad("treeChild<?php echo $ref ?>", "listetreenode.php?ref=<?php echo urlencode($ref) ?>&GroupBy=<?php echo $_REQUEST['GroupBy']?>", this)'><?php echo _out($display) ?></a>&nbsp;&nbsp;&nbsp;- (<?php echo $count?>)
</div>
<div class=treeChildNode id=treeChild<?php echo $ref ?> style="display:"></div>
<?php 
} 
?>
