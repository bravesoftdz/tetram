<?php
require_once '../routines.php';
?>
<?php
if (!isset($_REQUEST['action'])) $_REQUEST['action'] = '';
$groupby = !isset($_REQUEST['GroupBy']) ? 0 : $_REQUEST['GroupBy'];

switch ($_REQUEST['action'])
{
	case 'treenode':
		$ref = $_REQUEST['ref'];
		if ($ref == '-1') $ref = '';
		$ref = format_string_null($ref, true);

		switch ($groupby)
		{
			case 1: // par année
				$sql = 'select id_album, titrealbum, tome, tomedebut, tomefin, horsserie, integrale, moisparution, anneeparution, id_serie, titreserie, achat, complet from /*DB_PREFIX*/vw_liste_albums where anneeparution '.$ref.' order by coalesce(uppertitrealbum, uppertitreserie), uppertitreserie, horsserie, integrale, tome, tomedebut, tomefin, anneeparution, moisparution';
				break;
			case 2: // par collection
				$sql = 'select a.id_album, a.titrealbum, a.tome, a.tomedebut, a.tomefin, a.horsserie, a.integrale, a.moisparution, a.anneeparution, a.id_serie, s.titreserie, a.achat, a.complet from /*DB_PREFIX*/albums a left join /*DB_PREFIX*/editions e on a.id_album = e.id_album left join /*DB_PREFIX*/series s on a.id_serie = s.id_serie where e.id_collection '.$ref.' order by coalesce(uppertitrealbum, uppertitreserie), uppertitreserie, horsserie, integrale, tome, tomedebut, tomefin, anneeparution, moisparution';
				break;
			case 3: // par editeur
				$sql = 'select a.id_album, a.titrealbum, a.tome, a.tomedebut, a.tomefin, a.horsserie, a.integrale, a.moisparution, a.anneeparution, a.id_serie, s.titreserie, a.achat, a.complet from /*DB_PREFIX*/albums a left join /*DB_PREFIX*/editions e on a.id_album = e.id_album left join /*DB_PREFIX*/series s on a.id_serie = s.id_serie where e.id_editeur '.$ref.' order by coalesce(uppertitrealbum, uppertitreserie), uppertitreserie, horsserie, integrale, tome, tomedebut, tomefin, anneeparution, moisparution';
				break;
			case 4: // par genre
				$sql = 'select id_album, titrealbum, tome, tomedebut, tomefin, horsserie, integrale, moisparution, anneeparution, a.id_serie, titreserie, achat, complet from /*DB_PREFIX*/vw_liste_albums a left join /*DB_PREFIX*/genreseries gs on gs.id_serie = a.id_serie left join /*DB_PREFIX*/genres g on gs.id_genre = g.id_genre where g.id_genre '.$ref.' order by coalesce(uppertitrealbum, uppertitreserie), uppertitreserie, horsserie, integrale, tome, tomedebut, tomefin, anneeparution, moisparution';
				break;
			case 5: // par série
				$sql = 'select id_album, titrealbum, tome, tomedebut, tomefin, horsserie, integrale, moisparution, anneeparution, id_serie, titreserie, achat, complet from /*DB_PREFIX*/vw_liste_albums where id_serie '.$ref.' order by horsserie, integrale, tome, anneeparution, moisparution, uppertitrealbum';
				break;
			case 0:
			default: // par titre
				$sql = 'select a.id_album, a.titrealbum, a.tome, a.tomedebut, a.tomefin, a.horsserie, a.integrale, a.moisparution, a.anneeparution, a.id_serie, s.titreserie, a.achat, a.complet from /*DB_PREFIX*/albums a left join /*DB_PREFIX*/series s on s.id_serie = a.id_serie where coalesce(a.initialetitrealbum, s.initialetitreserie) '.$ref.' order by coalesce(uppertitrealbum, uppertitreserie), uppertitreserie, horsserie, integrale, tome, tomedebut, tomefin, anneeparution, moisparution';
		}
		$rs = load_sql($sql);
		while ($row = $rs->fetch_object()) 
			echo AjaxLink('album', $row->id_album, display_titrealbum($row, false, true)).'<br/>';
		break;
	default:
		if (!isset($_REQUEST['GroupBy']))
		{
?>
<div id=repertoire_header>
	<form method=post action=repinitiales.php>
		<select name=GroupBy id=GroupBy onChange="AjaxUpdate('repertoire_body', 'repertoire_albums.php?GroupBy='+this.options[this.selectedIndex].value, false);">
			<option value=0<?php echo $groupby == 0?' selected':''; ?>>Titre</option>
			<option value=5<?php echo $groupby == 5?' selected':''; ?>>Série</option>
			<option value=3<?php echo $groupby == 3?' selected':''; ?>>Editeur</option>
			<option value=2<?php echo $groupby == 2?' selected':''; ?>>Collection</option>
			<option value=4<?php echo $groupby == 4?' selected':''; ?>>Genre</option>
			<option value=1<?php echo $groupby == 1?' selected':''; ?>>Année de parution</option>
		</select>
	</form>
</div>
<div id=repertoire_body>
<?php
		}
		
		switch ($groupby)
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
		$rs = $db_link->query($sql) or die($db_link->error);
		$c = 0;
		while ($row = $rs->fetch_array(MYSQL_NUM)) 
		{
			$display = $row[0]=='-1' ? '&lt;Inconnu&gt;':format_titre($row[0]);
			if (count($row) == 2) 
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
    <a href='#' onclick='return treeLoad("treeChild<?php echo $ref ?>", "repertoire_albums.php?action=treenode&ref=<?php echo urlencode($ref) ?>&GroupBy=<?php echo $groupby ?>", this)'><?php echo _out($display) ?></a>&nbsp;&nbsp;&nbsp;- (<?php echo $count?>)
</div>
<div class=treeChildNode id=treeChild<?php echo $ref ?> style="display:"></div>
<?php 
		}

		if (!isset($_REQUEST['GroupBy']))
		{
?>
</div>
<?php
		}
}	
?>