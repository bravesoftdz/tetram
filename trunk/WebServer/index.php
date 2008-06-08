<?
require_once 'db.php';
require_once 'routines.php';
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//FR">
<HTML>
	<HEAD>
		<TITLE>BDThèque</TITLE>
		<LINK rel=stylesheet href=styles.css type=text/css>
<?
 if (ereg("MSIE", $_SERVER["HTTP_USER_AGENT"])) 
	echo "		<LINK rel=stylesheet href=stylesIE.css type=text/css>\n";
else
	echo "		<LINK rel=stylesheet href=stylesOther.css type=text/css>\n";
?>
		<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script language="JavaScript" type="text/JavaScript" src=ajax.js></script>
		<script language="JavaScript" type="text/JavaScript">
			function firstLoad()
			{
				AjaxUpdate('listeinitiales-body', 'listeinitiales.php?GroupBy=' + getById('GroupBy').options[getById('GroupBy').selectedIndex].value);
				return true;
			}
		</script>
	</HEAD>
	<BODY onload="firstLoad();">
		
<div id=wait style='display: none'><img src=graphics/loading.gif valign=center>&nbsp;Chargement des données...</div>

<div id=listeinitiales-header>
	<a href='#' onclick='AjaxUpdate("listealbums", "manquants.php")'>Séries incomplètes</a><br>
	<a href='#' onclick='AjaxUpdate("listealbums", "previsions.php")'>Prévisions de sorties</a><p>
	<form method=post action=repinitiales.php>
		<select name=GroupBy id=GroupBy onChange="AjaxUpdate('listeinitiales-body', 'listeinitiales.php?GroupBy='+this.options[this.selectedIndex].value, false);">
			<option value=0<? echo $_REQUEST['GroupBy'] == 0?' selected':''; ?>>Titre</option>
			<option value=5<? echo $_REQUEST['GroupBy'] == 5?' selected':''; ?>>Série</option>
			<option value=3<? echo $_REQUEST['GroupBy'] == 3?' selected':''; ?>>Editeur</option>
			<option value=2<? echo $_REQUEST['GroupBy'] == 2?' selected':''; ?>>Collection</option>
			<option value=4<? echo $_REQUEST['GroupBy'] == 4?' selected':''; ?>>Genre</option>
			<option value=1<? echo $_REQUEST['GroupBy'] == 1?' selected':''; ?>>Année de parution</option>
		</select>
	</form>
</div>
<div id=listeinitiales-body> </div>

<div id=listealbums></div>
<div id=detail></div>
<div id=zoom style='display: none'>
	<img id=zoomimage onclick='getById("zoom").style.display = "none";'>
	<br /><font size=1>Cliquez sur l'image pour fermer le zoom</font>
</div>

<div id=bottombar>
<?
$albums = load_and_fetch('select count(*) as c from /*DB_PREFIX*/albums');
$editions = load_and_fetch('select count(*) as c from /*DB_PREFIX*/editions');
$series = load_and_fetch('select count(*) as c from /*DB_PREFIX*/series');
$auteurs = load_and_fetch('select count(*) as c from /*DB_PREFIX*/personnes');
$editeurs = load_and_fetch('select count(*) as c from /*DB_PREFIX*/editeurs');
?>
	<TABLE cellpadding=0 cellspacing=0 border=0 width=100% height=100%>
		<tr height=100%>
			<td valign=bottom>
				<b><?echo $albums->c?></b> albums connus pour <b><?echo $editions->c?></b> albums dans la biliothèque,<br>
				répartis sur <b><?echo $series->c?></b> séries chez <b><?echo $editeurs->c?></b> éditeurs,<br>
				et réalisés par <b><?echo $auteurs->c?></b> auteurs.
			</td>
			<td valign=bottom align=right>
				<font size=1>Site généré par <a href=http://www.tetram.org/bdtheque target=_blank>BDthèque</a></font>
			</td>
		</TR>
	</TABLE>
</div>

	</BODY>
</HTML>
