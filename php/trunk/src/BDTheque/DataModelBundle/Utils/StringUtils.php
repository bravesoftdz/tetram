<?php

namespace BDTheque\DataModelBundle\Utils;

use BDTheque\DataModelBundle\Entity\Serie;
use BDTheque\DataModelBundle\Entity\Editeur;
use BDTheque\DataModelBundle\Entity\Collection;

abstract class StringUtils {

    private final function __construct() {
        
    }

    public static function stripAccents($chaine) {
        return utf8_encode(strtr(utf8_decode($chaine), utf8_decode('àáâãäçèéêëìíîïñòóôõöùúûüýÿÀÁÂÃÄÇÈÉÊËÌÍÎÏÑÒÓÔÕÖÙÚÛÜÝ'), 'aaaaaceeeeiiiinooooouuuuyyAAAAACEEEEIIIINOOOOOUUUUY'));
    }

    public static function extractInitialeFromString($chaine) {
        $fc = ucfirst(self::stripAccents(substr(trim($chaine), 0, 1)));
        if (!ctype_alnum($fc))
            $fc = '#';
        return $fc;
    }

    public static function formatTitre($titre) {
        $i = strpos($titre, '[');
        if (is_int($i)) {
            $j = strpos($titre, ']', $i);
            if (is_int($j)) {
                $dummy = substr($titre, $i + 1, $j - $i - 1);
                if ($j - $i > 1 && substr($dummy, -1, 1) != "'")
                    $dummy .= ' ';
                $titre = $dummy . substr($titre, 0, $i - 1) . substr($titre, $j + 1);
            }
        }

        return trim($titre);
    }

    public static function ajoutString(&$chaine, $ajout, $espace, $avant = '', $apres = '') {
        $s = $ajout;
        if ($ajout != '') {
            $s = $avant . $ajout . $apres;
            if ($chaine != '')
                $chaine .= $espace;
        }
        $chaine .= $s;
    }

    /*
      public static function buildTitreAlbum($simple, $avecserie, $titrealbum, $titreserie, $tome, $tomedebut, $tomefin, $integrale, $horsserie) {
      global $FormatTitreAlbum;

      if (!isset($FormatTitreAlbum))
      $FormatTitreAlbum = get_option('formattitrealbum');

      $sAlbum = $titrealbum;
      if (!$simple)
      $sAlbum = format_titre($sAlbum);

      $sSerie = '';
      if ($avecserie)
      if ($sAlbum == '')
      $sAlbum = format_titre($titreserie);
      else
      $sSerie = format_titre($titreserie);

      $sTome = '';
      if ($integrale) {
      $s2 = NonZero($tomedebut);
      AjoutString($s2, NonZero($tomefin), ' à ');
      AjoutString($sTome, ($sAlbum ? 'INT.' : 'Intégrale'), ' - ', '', rtrim(' ' . NonZero($tome)));
      AjoutString($sTome, $s2, ' ', '[', ']');
      } elseif ($horsserie)
      AjoutString($sTome, ($sAlbum ? 'HS' : 'Hors-série'), ' - ', '', rtrim(' ' . NonZero($tome)));
      else
      AjoutString($sTome, NonZero($tome), ' - ', ($sAlbum ? 'T. ' : 'Tome '));

      switch ($FormatTitreAlbum) {
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
      else {
      AjoutString($sAlbum, $sSerie, ' ', '(', ')');
      $result = $sAlbum;
      }
      }

      if ($result == '')
      return '&lt;Sans titre&gt;';
      else
      return $result;
      }
     */
    /*
      public static function displayTitreAlbum($album, $simple = false, $avecserie = false) {
      return build_titrealbum($simple, $avecserie, $album->titrealbum, $album->titreserie, $album->tome, $album->tomedebut, $album->tomefin, $album->integrale, $album->horsserie);
      }
     */

    public static function buildTitreSerie($simple, $titreserie, Editeur $editeur, Collection $collection = null) {
        if ($simple)
            $result = $titreserie;
        else
            $result = static::formatTitre($titreserie);
        $s = '';
        static::ajoutString($s, static::formatTitre($editeur->getNomEditeur()), ' ');
        if ($collection != null)
            static::ajoutString($s, static::formatTitre($collection->getNomCollection()), ' - ');
        static::ajoutString($result, $s, ' ', '(', ')');
        return $result;
    }

    public static function displayTitreSerie(Serie $serie, $simple = false) {
        return static::buildTitreSerie($simple, $serie->getTitre(), $serie->getEditeur(), $serie->getCollection());
    }

    /**
     * @see http://www.isbn-international.org/page/ranges
     */
    public static function formatISBN($isbn) {
        $resourceDirectory = array(__DIR__ . '/../Resources');
        $locator = new \Symfony\Component\Config\FileLocator($resourceDirectory);
        $isbnFile = $locator->locate('ISBNRanges.xml');
        $xml = simplexml_load_file($isbnFile);

        $isbn = substr(strtoupper($isbn), 0, 13);
        $s = $isbn;
        $prefix = '978';
        if (strlen($s) > 10) {
            $prefix = substr($s, 0, 3);
            $s = substr($s, 3, 10);
        }
        if (strlen($s) < 10)
            return $isbn;

        $c = substr($s, 0, 7);
        $group_size = intval(strip_tags($xml->xpath("/ISBNRangeMessage/EAN.UCCPrefixes/EAN.UCC[Prefix='$prefix']/Rules/Rule[ValueLower<=$c and ValueUpper>=$c]/Length")[0]->asXML()));
        $group = substr($s, 0, $group_size);

        $c = substr($s, $group_size, 7);
        $publisher_size = intval(strip_tags($xml->xpath("/ISBNRangeMessage/RegistrationGroups/Group[Prefix='$prefix-$group']/Rules/Rule[ValueLower<=$c and ValueUpper>=$c]/Length")[0]->asXML()));
        $publisher = substr($s, $group_size, $publisher_size);

        $result = $group . '-' . $publisher . '-' . substr($s, $group_size + $publisher_size, 9 - $group_size - $publisher_size) . '-' . substr($s, -1, 1);
        if (strlen($isbn) > 10)
            $result = $prefix . '-' . $result;
        return $result;
    }

}

?>
