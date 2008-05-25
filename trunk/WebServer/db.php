<?
require_once 'config.inc';

if (substr($db_prefix, -1, 1) != '_') $db_prefix .= '_';
$db_ok = mysql_connect($db_host, $db_user, $db_pass) && mysql_select_db($db_name);
if (substr($rep_images, strlen($rep_images), -1) != '/') $rep_images .= '/';

function prepare_sql(&$sql)
{
	global $db_prefix;
	$patterns[0] = '/(\/\*DB_PREFIX\*\/)/';
	$replacements[0] = $db_prefix;

	$sql = preg_replace($patterns, $replacements, $sql);
}

function format_string_null($string, $is_where = false)
{
	if ($string == null || $string == '') 
		return ($is_where?'IS ':'= ').'NULL';
	else
		//return "= '".str_replace("'", "''", $string)."'";
		return "= '".addslashes($string)."'";
}

?>