<?
require_once 'db.php';
?>
<P>
    <A href="javascript:history.back();">Retour</A> - <A href="repertoire.php">Répertoire</A> - <a href="javascript:window.location.reload(true);">Rafraichir</a><br>
    <hr align=left width=50>
    <font size=-2>Page générée en <?echo sprintf('%.3f', gettimeofday(true) - $start_time)?> secondes avec <?echo $nb_requetes_sql?> requête(s) sql.</font>
	</BODY>
</HTML>
