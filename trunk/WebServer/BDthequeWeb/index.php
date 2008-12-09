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
		<script language="JavaScript" type="text/JavaScript" src=commun.js></script>
		<script language="JavaScript" type="text/JavaScript" src=classes.js></script>
		<script language="JavaScript" type="text/JavaScript" src=ajax.js></script>
		<script language="JavaScript" type="text/JavaScript" src=bdtheque.js></script>
		<script language="JavaScript" type="text/JavaScript">
			function firstLoad()
			{
				selectTab('repertoire', 'repertoire_albums.php', 'tab_repalbums', 'repertoire_tabs');
				refreshNavigation();
				return true;
			}
			
			sfHover = function() {
				historique_mouseover = function(e) { 
					e.srcElement.className += " sfhover";
				}
				historique_mouseout = function(e) { 
					e.srcElement.className = e.srcElement.className.replace(new RegExp(" sfhover\\b"), ""); 
				}
				
				var Btn = getById('historiqueBack');
				if (Btn) 
				{
					Btn.attachEvent('onmouseover', historique_mouseover);
					Btn.attachEvent('onmouseout', historique_mouseout);
				}
				var Btn = getById('historiqueForward');
				if (Btn) 
				{
					Btn.attachEvent('onmouseover', historique_mouseover);
					Btn.attachEvent('onmouseout', historique_mouseout);
				}
			}
			if (window.attachEvent) window.attachEvent("onload", sfHover);
		</script>
	</HEAD>
	<BODY onload="firstLoad();">
		
<div id=wait style='display: none'><img src=graphics/loading.gif valign=center>&nbsp;Chargement des données...</div>

<div id=repertoire_tabs class=tabcontrol>
	<div id=tab_repalbums class=tabsheet onclick="selectTab('repertoire', 'repertoire_albums.php', 'tab_repalbums', 'repertoire_tabs')">Albums</div>
	<div id=tab_repseries class=tabsheet onclick="selectTab('repertoire', 'repertoire_series.php', 'tab_repseries', 'repertoire_tabs')">Séries</div>
	<div id=tab_repauteurs class=tabsheet onclick="selectTab('repertoire', 'repertoire_auteurs.php', 'tab_repauteurs', 'repertoire_tabs')">Auteurs</div>
</div>
<div id=repertoire></div>

<div id=detail></div>
<div id=zoom style='display: none'>
	<img id=zoomimage onclick='getById("zoom").style.display = "none";'>
	<br /><font size=1>Cliquez sur l'image pour fermer le zoom</font>
</div>

<div id=historiqueBack class='btnHistorique historiqueBack' onclick='backHistorique()' onmouseover='showListeHistorique(true)' title='Page précédente'></div>
<div id=listeHistoriqueBack class=listeHistorique onmousemove='resetHistoriqueTimer()'></div>
<div id=historiqueForward class='btnHistorique historiqueForward' onclick='forwardHistorique()' onmouseover='showListeHistorique(false)' title='Page suivante'></div>
<div id=listeHistoriqueForward class=listeHistorique onmousemove='resetHistoriqueTimer()'></div>

<div id=topbar>
	<div id=toolBar>
		<div id=toolManquants class=toolButton onclick='AjaxUpdate("detail", "manquants.php", this.title)' title="Séries incomplètes"></div>
		<div id=toolPrevisions class=toolButton onclick='AjaxUpdate("detail", "previsions.php", this.title)' title="Prévisions de sorties"></div>
		<div id=toolAchats class=toolButton onclick='AjaxUpdate("detail", "listeachats.php", this.title)' title="Prévisions d'achats"></div>
	</div>
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
				<br>
				<a href=# onclick='AjaxUpdate("detail", "modifs.php", this.title)' title="Dernières modifications">Dernières modifications</a>
			</td>
			<td valign=bottom align=right>
				<font size=1>Site généré par <a href=http://www.tetram.org/bdtheque target=_blank>BDthèque</a></font>
			</td>
		</TR>
	</TABLE>
</div>

	</BODY>
</HTML>
