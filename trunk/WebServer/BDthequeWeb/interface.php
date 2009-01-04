<?
if (!isset($_REQUEST['isExe'])) echo "<pre>\n";

$intf_version = '1';
require_once 'db.php';

function Message($code, $msg)
{
	if (is_string($msg))
		foreach(split("\r\n", $msg) as $l)
			if (isset($_REQUEST['isExe']))
				echo "$code: $l\n";
			else
				echo "$code: ".htmlentities($l)."\n";
	elseif (is_array($msg))
		foreach($msg as $l)
			Message($code, $l);
	else
		Message($code, print_r($msg, true));
}

if ($_REQUEST['auth_key'] != $db_key) {
	Message('ERROR', 'Auth key required');
	exit;
}

function OnErrorDoNothing($errno, $errstr) {}

function xml2ary(&$string) {
	$parser = xml_parser_create('UTF-8'); 
	xml_parser_set_option($parser, XML_OPTION_CASE_FOLDING, 0);
	xml_parse_into_struct($parser, $string, $vals, $index);
	xml_parser_free($parser);

	$mnary=array();
	$ary=&$mnary;
	foreach ($vals as $r) 
	{
		$t=$r['tag'];
		switch ($r['type'])
		{
			case 'open':
				if (isset($ary[$t])) 
				{
					if (isset($ary[$t][0])) 
						$ary[$t][] = array(); 
					else 
						$ary[$t] = array($ary[$t], array());
					$cv = &$ary[$t][count($ary[$t])-1];
				} 
				else 
					$cv = &$ary[$t];
				if (isset($r['attributes'])) foreach ($r['attributes'] as $k=>$v) $cv['_a'][$k] = $v;
				$cv['_c'] = array();
				$cv['_c']['_p'] = &$ary;
				$ary = &$cv['_c'];
				break;
			case 'complete':
				if (isset($ary[$t])) 
				{ // same as open
					if (isset($ary[$t][0])) 
						$ary[$t][] = array(); 
					else 
						$ary[$t] = array($ary[$t], array());
					$cv = &$ary[$t][count($ary[$t])-1];
				} 
				else 
					$cv = &$ary[$t];
				if (isset($r['attributes'])) foreach ($r['attributes'] as $k=>$v) $cv['_a'][$k] = $v;
				$cv['_v'] = (isset($r['value']) ? $r['value'] : '');
				break;
			case 'close':
				$ary = &$ary['_p'];
				break;
		}
	}    
	
	_del_p($mnary);
	return $mnary;
}

function _del_p(&$ary) {
	foreach ($ary as $k=>$v) {
		if ($k==='_p') unset($ary[$k]);
		elseif (is_array($ary[$k])) _del_p($ary[$k]);
	}
}

function build_img_filepath($root, $prefix, $id) {
    $dir = substr(str_replace(array('{', '}', '-'), '', $id), 0, 3).'/';
    $dir = substr_replace($dir, '/', 2, 0);
    $dir = substr_replace($dir, '/', 1, 0);
    return $root.$dir.$prefix.$id.'.jpg';
}

# Extract from MediaWiki
function wfMkdirParents( $fullDir, $mode = null ) {
	global $wgDirectoryMode;
    $wgDirectoryMode = 0700;
    
	if( strval( $fullDir ) === '' )
		return true;
	if( file_exists( $fullDir ) )
		return true;
	// If not defined or isn't an int, set to default
	if ( is_null( $mode ) ) {
		$mode = $wgDirectoryMode;
	}


	# Go back through the paths to find the first directory that exists
	$currentDir = $fullDir;
	$createList = array();
	while ( strval( $currentDir ) !== '' && !file_exists( $currentDir ) ) {
		# Strip trailing slashes
		$currentDir = rtrim( $currentDir, '/\\' );

		# Add to create list
		$createList[] = $currentDir;

		# Find next delimiter searching from the end
		$p = max( strrpos( $currentDir, '/' ), strrpos( $currentDir, '\\' ) );
		if ( $p === false ) {
			$currentDir = false;
		} else {
			$currentDir = substr( $currentDir, 0, $p );
		}
	}

	if ( count( $createList ) == 0 ) {
		# Directory specified already exists
		return true;
	} elseif ( $currentDir === false ) {
		# Went all the way back to root and it apparently doesn't exist
		Message('ERROR', "mkdir: Root doesn't exist?\n" );
		return false;
	}
	# Now go forward creating directories
	$createList = array_reverse( $createList );

	# Is the parent directory writable?
	if ( $currentDir === '' ) {
		$currentDir = '/';
	}
	if ( !is_writable( $currentDir ) ) {
		Message('ERROR', "mkdir: Not writable: $currentDir\n" );
		return false;
	}

	foreach ( $createList as $dir ) {
		# use chmod to override the umask, as suggested by the PHP manual
		if ( !mkdir( $dir, $mode ) || !chmod( $dir, $mode ) ) {
			Message('ERROR', "mkdir: Unable to create directory $dir\n" );
			return false;
		}
	}
	return true;
}

$action = $_REQUEST['action'];
if (!$action) $action = 0;

switch ($action)
{
	case 0:
	{
		Message('INFO', "intf_version=$intf_version");
		preg_match("/^(\d+)\.(\d+)(\.(\d+))*/", phpversion(), $php_version);
		$php_version = $php_version[0];
		Message('INFO', "php_version=$php_version ".(version_compare($php_version, $php_version_mini, '>=')?'(OK)':'(KO)'));
		Message('INFO', 'XML='.(function_exists('xml_parser_create')?'(OK)':'(KO)'));
		Message('INFO', 'JSON='.(function_exists('json_decode')?'(OK)':'(KO)'));        

		set_error_handler('OnErrorDoNothing');

		if ($db_ok) { 
			preg_match("/^(\d+)\.(\d+)(\.(\d+))*/", mysql_get_server_info(), $mysql_version);
			$mysql_version = $mysql_version[0];
			Message('INFO', "mysql_version=$mysql_version ".(version_compare($mysql_version, $mysql_version_mini, '>=')?'(OK)':'(KO)'));
	
			$rs = mysql_query("select valeur from ".$db_prefix."options where cle = 'version'");
			Message('INFO', "db_version=".($rs && ($row = mysql_fetch_object($rs))?$row->valeur:'0.0.0.0'));
			if ($rs) mysql_free_result($rs);
		}
		else
		{
			Message('ERROR', 'incorrect db params');
			Message('INFO', mysql_error());
		}
			
		restore_error_handler;
		break;
	}
	case 1: // DDL
	{
		$data = base64_decode($_REQUEST['data']);
		if (!$data) 
		{
			Message('ERROR', 'empty data');
			exit;
		}

		$lines = split("@@", $data);
		foreach($lines as $sql)
		if (trim($sql) != '') {
			prepare_sql($sql);
			if (!mysql_query($sql)) 
			{
				Message('ERROR', mysql_error());
				Message('INFO', $sql);
				exit;
			}
		}
		
		Message('INFO', 'done');
		break;
	}
	case 2: // Data
	{
		$data = base64_decode($_REQUEST['data']);
		if (!$data) 
		{
			Message('ERROR', 'empty data');
			exit;
		}
		
		$xml = xml2ary($data);
		
		$table = $db_prefix.$xml['data']['_c']['table']['_v'];
		$primary_key = $xml['data']['_c']['primarykey']['_v'];

		if (!$table) 
		{
			Message('ERROR', 'required data missing');
			Message('INFO', 'table name');
			exit;
		}
		
		$rs = mysql_query("SHOW COLUMNS FROM $table");
		if (!$rs)
		{
			Message('ERROR', 'unknown table');
			Message('INFO', "$table");
			exit;
		}
		if ($primary_key) 
		{   
			$xml_primary_key = $primary_key;
			$primary_key = '';
			while ($row = mysql_fetch_object($rs)) 
				if ($row->Field == $xml_primary_key)
				{
					$primary_key = $row->Field;
					break;
				}
			if ($primary_key == '') 
			{
				Message('ERROR', 'unknown primary key');
				Message('INFO', $xml_primary_key);
				Message('INFO', $table);
				exit;
			}
		}
		mysql_free_result($rs);     
		
		if (array_key_exists('_c', $xml['data']['_c']['records']['_c']['record']))
			$records = $xml['data']['_c']['records']['_c'];
		else            
			$records = $xml['data']['_c']['records']['_c']['record'];
		foreach($records as $record)
		{
			$is_delete = $record['_a']['action'] == 'D';
			if ($primary_key && $record['_c'][$primary_key]['_v'] && ($record['_c'][$primary_key]['_v'] == ''))
			 {
				Message('ERROR', 'missing primary key value');
				Message('INFO', $record);
				exit;
			}
			
			$sql_insert = '';
			$sql_update = '';
			$sql_where = '';
			foreach ($record['_c'] as $prop => $value)
			{
				if (substr($prop, 0, 1) == '_') continue;
				$v = $value['_v'];
				if ($value['_a']['type'] == 'B') $v = base64_decode($v);
				$sql_insert .= ($sql_insert == ''?'':', ').$prop.' '.format_string_null($v);
				$sql_where .= ($sql_where == ''?'':' and ').$prop.' '.format_string_null($v, true);
				if ($prop != $primary_key) $sql_update .= ($sql_update == ''?'':', ')."$prop = values($prop)";
			}

			if ($is_delete)
				$sql = "delete from $table".($sql_where != ''?' where '.$sql_where:'');
			else
				$sql = "insert into $table set $sql_insert on duplicate key update $sql_update";
			if (!mysql_query($sql))
			{
				Message('ERROR', 'error during '.($is_delete?'delete':'insert/update'));
				Message('INFO', mysql_error());
				Message('INFO', $sql);
				Message('INFO', print_r($xml, true));
				exit;
			}
		}

		Message('INFO', 'done');
		break;
	}
	case 3: // valeur option
	{
		Message('INFO', get_option($_REQUEST['cle']));
		break;
	}
	
	case 4: // Création du répertoire des affiches (si besoin)
	{
		$result = false;
		if (!is_dir($rep_images)) {
			$result = mkdir($rep_images);
			if ($result===false) 
			{	
				Message('ERROR', 'cannot create');
				exit;
			}
		}
		Message('INFO', 'done'); 
		if (!$result) Message('INFO', 'already created');
		break;
	}		
	case 5: // Effacer une image
	{
		$filename = build_img_filepath($rep_images, $db_prefix, base64_decode($_REQUEST['ID']));
		if (file_exists($filename)) 
		{ 
			unlink($filename); 
			Message('INFO', 'done');
			exit;
		}
		Message('ERROR', 'file not found');
		Message('INFO', $filename);
		break;
	}
	case 6: // effacer toutes les images
	{
		$cpt = 0;
		if ($handle = @opendir($rep_images)) 
		{
			while ($file = readdir($handle)) 
			{
				if ($file != "." && $file != "..") 
				{
					if ((substr($file, 0, strlen($db_prefix)) == $db_prefix) && (substr($file, -4) == ".jpg"))
					{ 
						unlink($rep_images.$file); 
						$cpt+=1; 
					}
				}
			}
			closedir($handle);
		}
		Message('INFO', 'done');
		Message('INFO', "$cpt images deleted");
		break;
	}
	case 7: // ajout d'une image
	{
		$image = base64_decode($_REQUEST['image']);
		$filename = build_img_filepath($rep_images, $db_prefix, base64_decode($_REQUEST['ID']));
        if (!wfMkdirParents(dirname($filename)))
        {
			Message('ERROR', 'unable to create dir');
			Message('INFO', $filename);
			exit;
        }
		if (!$handle = fopen($filename, 'wb')) 
		{
			Message('ERROR', 'unable to open file');
			Message('INFO', $filename);
			exit;
		}
		if (fwrite($handle, $image) === FALSE) 
		{
			Message('ERROR', 'unable to write into file');
			Message('INFO', $filename);
			exit;
		}
		else 
		{ 
			Message('INFO', 'done');
			Message('INFO', 'image stored in '.$filename);
		}
		fclose($handle);
		break;
	}
	case 8: // image existe ?
		$filename = build_img_filepath($rep_images, $db_prefix, base64_decode($_REQUEST['ID']));
		if (file_exists($filename)) 
			Message('INFO', 'file exists');
		else
			Message('INFO', 'file not found');
		Message('INFO', $filename);
		break;
	default:
	{
		Message('ERROR', 'unkonwn action');
		Message('INFO', $action);
		break;
	}
}

if (!isset($_REQUEST['isExe'])) echo "</pre>\n";
?>
