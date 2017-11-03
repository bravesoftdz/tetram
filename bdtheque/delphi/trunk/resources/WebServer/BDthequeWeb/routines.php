<?php
require_once 'db.php';
unset($FormatTitreAlbum);

function format_titre($titre)
{
	$i = strpos($titre, '[');
	if (is_int($i))
	{
		$j = strpos($titre, ']', $i);
		if (is_int($j))
		{
			$temp = substr($titre, $i + 1, $j - $i - 1);
			if (strlen($temp) > 0 && substr($temp, -1, 1) != "'") $temp .= ' ';
			$titre = $temp.substr($titre, 0, $i - 1).substr($titre, $j + 1);
		}
	}
	return trim($titre);
}

function build_img_filepath($root, $prefix, $id) {
    // attention: fonction dupliqu�e dans interface.php
    $dir = substr(str_replace(array('{', '}', '-'), '', $id), 0, 3).'/';
    $dir = substr_replace($dir, '/', 2, 0);
    $dir = substr_replace($dir, '/', 1, 0);
    return $root.$dir.$prefix.$id.'.jpg';
}

$mois = array('1' => 'janvier', '2' => 'février', '3' => 'mars', '4' => 'avril',
			  '5' => 'mai', '6' => 'juin', '7' => 'juillet', '8' => 'août',
			  '9' => 'septembre', '10' => 'octobre', '11' => 'novembre', '12' => 'décembre');
$jours = array('0' => 'dimanche', '1' => 'lundi', '2' => 'mardi', '3' => 'mercredi',
			   '4' => 'jeudi', '5' => 'vendredi', '6' => 'samedi');

function AfficheDateSQL($dateSQL) {
	global $mois, $jours;
	
	if ($dateSQL)
		return ucfirst($jours[date("w", strtotime($dateSQL))]).date(" d ", strtotime($dateSQL)).$mois[date("n", strtotime($dateSQL))].date(" Y", strtotime($dateSQL));
	else
		return '';
}

function AjoutString(&$Chaine, $Ajout, $Espace, $Avant = '', $Apres = '')
{
	$s = $Ajout;
	if ($Ajout != '') 
	{
		$s = $Avant.$Ajout.$Apres;
		if ($Chaine != '') $Chaine .= $Espace;
	}
	$Chaine .= $s;
}

function NonZero($s)
{
	if (trim($s) == '0')
		return '';
	else
		return $s;
}

function build_titrealbum($simple, $avecserie, $titrealbum, $titreserie, $tome, $tomedebut, $tomefin, $integrale, $horsserie)
{
	global $FormatTitreAlbum;
	
	if (!isset($FormatTitreAlbum)) $FormatTitreAlbum = get_option('formattitrealbum');
	
	$sAlbum = $titrealbum;
	if (!$simple) $sAlbum = format_titre($sAlbum);

	$sSerie = '';
	if ($avecserie) 
		if ($sAlbum == '')
			$sAlbum = format_titre($titreserie);
		else
			$sSerie = format_titre($titreserie);

	$sTome = '';
	if ($integrale) 
	{
		$s2 = NonZero($tomedebut);
		AjoutString($s2, NonZero($tomefin), ' à ');
		AjoutString($sTome, ($sAlbum?'INT.':'Intégrale'), ' - ', '', rtrim(' '.NonZero($tome)));
		AjoutString($sTome, $s2, ' ', '[', ']');
	}
	elseif ($horsserie) 
		AjoutString($sTome, ($sAlbum?'HS':'Hors-série'), ' - ', '', rtrim(' '.NonZero($tome)));
	else
		AjoutString($sTome, NonZero($tome), ' - ', ($sAlbum?'T. ':'Tome '));

	switch ($FormatTitreAlbum)
	{
		case 1: // Tome - Album (Serie)
			if ($sAlbum == '')
				$sAlbum = $sSerie;
			else
				AjoutString($sAlbum, $sSerie, ' ', '(', ')');
			AjoutString($sTome, $sAlbum, ' - ');
			$result = $sTome;
			break;
		case 0: // Album (Serie - Tome)
		default:
			AjoutString($sSerie, $sTome, ' - ');
			if ($sAlbum == '') 
				$result = $sSerie;
			else
			{
				AjoutString($sAlbum, $sSerie, ' ', '(', ')');
				$result = $sAlbum;
			}
	}

	if ($result == '') 
		return  '&lt;Sans titre&gt;';
	else
		return $result;
}

function display_titrealbum($album, $simple = false, $avecserie = false)
{
	return build_titrealbum(
		$simple, 
		$avecserie, 
		$album->titrealbum, 
		property_exists($album, 'titreserie') ? $album->titreserie : '', 
		$album->tome, 
		$album->tomedebut, 
		$album->tomefin, 
		$album->integrale, 
		$album->horsserie
	);
}

function build_titreserie($simple, $titreserie, $editeur, $collection)
{
	if ($simple) 
		$result = $titreserie;
	else
		$result = format_titre($titreserie);
	$s = '';
	AjoutString($s, format_titre($editeur), ' ');
	AjoutString($s, format_titre($collection), ' - ');
	AjoutString($result, $s, ' ', '(', ')');
	return $result;
}

function display_titreserie($serie, $simple = false)
{
	return build_titreserie(
		$simple, 
		$serie->titreserie, 
		property_exists($serie, 'nomediteur') ? $serie->nomediteur : '', 
		property_exists($serie, 'nomcollection') ? $serie->nomcollection : ''
	);
}

function format_isbn($isbn)
{
	$isbn = substr(strtoupper($isbn), 0, 13);
	$s = $isbn;
	if (strlen($s) > 10) $s = substr($s, 3, 10);
	if (strlen($s) < 10) return $isbn;

	$l = -1;
	sscanf(substr($s, 0, 1), '%d', $c);
	switch ($c) 
	{
		case 0:
		case 3:
		case 4:
		case 5: // codes anglophones
			sscanf(substr($s, 1, 2), '%d', $c);
			if ($c >= 00 && $c <= 19) $l = 2;
			if ($c >= 20 && $c <= 69) $l = 3;
			if ($c >= 70 && $c <= 84) $l = 4;
			if ($c >= 85 && $c <= 89) $l = 5;
			if ($c >= 90 && $c <= 94) $l = 6;
			if ($c >= 95 && $c <= 99) $l = 7;
			break;
		case 2: // codes francophones
			sscanf(substr($s, 1, 2), '%d', $c);
			if ($c >= 01 && $c <= 19) $l = 2;
			if ($c >= 20 && $c <= 34) $l = 3;
			if ($c >= 40 && $c <= 69) $l = 3;
			if ($c >= 70 && $c <= 83) $l = 4;
			if ($c >= 84 && $c <= 89) $l = 5;
			if ($c >= 35 && $c <= 39) $l = 5;
			if ($c >= 90 && $c <= 94) $l = 6;
			if ($c >= 95 && $c <= 99) $l = 7;
			break;
		case 1:
			sscanf(substr($s, 1, 6), '%d', $c);
			if ($c >= 550000 && $c <= 869799) $l = 5;
			if ($c >= 869800 && $c <= 926429) $l = 6;
			break;
		case 7:
			sscanf(substr($s, 1, 2), '%d', $c);
			if ($c >= 00 && $c <= 09) $l = 2;
			if ($c >= 10 && $c <= 49) $l = 3;
			if ($c >= 50 && $c <= 79) $l = 4;
			if ($c >= 80 && $c <= 89) $l = 5;
			if ($c >= 90 && $c <= 99) $l = 6;
			break;
		case 8:
			sscanf(substr($s, 1, 1), '%d', $c);
			switch ($c)
			{
				case 1:
				case 3:
				case 4: 
				case 5:
				case 8:
					sscanf(substr($s, 2, 2), '%d', $c);
					if ($c >= 00 && $c <= 19) $l = 2;
					if ($c >= 20 && $c <= 69) $l = 3;
					if ($c >= 70 && $c <= 84) $l = 4;
					if ($c >= 85 && $c <= 89) $l = 5;
					if ($c >= 90 && $c <= 99) $l = 6;
					break;
			}
			break;
		case 9:
			sscanf(substr($s, 1, 1), '%d', $c);
			switch ($c)
			{
				case 0:
					sscanf(substr($s, 2, 2), '%d', $c);
					if ($c >= 00 && $c <= 19) $l = 3;
					if ($c >= 20 && $c <= 49) $l = 4;
					if ($c >= 50 && $c <= 69) $l = 5;
					if ($c >= 70 && $c <= 79) $l = 6;
					if ($c >= 80 && $c <= 89) $l = 7;
					break;
				case 2:
					sscanf(substr($s, 2, 2), '%d', $c);
					if ($c >= 00 && $c <= 05) $l = 2;
					if ($c >= 06 && $c <= 07) $l = 3;
					if ($c >= 80 && $c <= 89) $l = 4;
					if ($c >= 90 && $c <= 99) $l = 5;
					break;
			}
			break;
	}

	if ($l == -1) return $isbn;
	$result = sprintf('%s-%s-%s-%s', substr($s, 0, 1), substr($s, 1, $l), substr($s, 1 + $l, 8 - $l), substr($s, 9, 1));
	if (strlen($isbn) > 10) $result = substr($isbn, 0, 3).'-'.$result;
	return $result;
}

function detectUTF8($str)
{
	return preg_match('%(?:
		[\xC2-\xDF][\x80-\xBF]        # non-overlong 2-byte
		|\xE0[\xA0-\xBF][\x80-\xBF]               # excluding overlongs
		|[\xE1-\xEC\xEE\xEF][\x80-\xBF]{2}      # straight 3-byte
		|\xED[\x80-\x9F][\x80-\xBF]               # excluding surrogates
		|\xF0[\x90-\xBF][\x80-\xBF]{2}    # planes 1-3
		|[\xF1-\xF3][\x80-\xBF]{3}                  # planes 4-15
		|\xF4[\x80-\x8F][\x80-\xBF]{2}    # plane 16
		)+%xs', $str);
}

function _out($str)
{
	if (!detectUTF8($str))
		return utf8_encode($str);
	else
		return $str;
}

function AjaxLink($type, $id, $titre, $category='')
{
?>
<a href=# onclick='return AjaxUpdate("detail", "fiche<?php echo $type?>.php?ref=<?php echo $id ?>", "<?php echo ucfirst($category!=''?$category:$type)?> : " + this.title)' title="<?php echo _out(htmlspecialchars($titre)) ?>"><?php echo _out($titre) ?></a>
<?php
}

?>