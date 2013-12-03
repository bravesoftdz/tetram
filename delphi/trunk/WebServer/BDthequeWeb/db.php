<?php
require_once 'config.inc';

if (substr($db_prefix, -1, 1) != '_') $db_prefix .= '_';
$db_link = new mysqli($db_host, $db_user, $db_pass, $db_name) or die($db_link->connect_error);
if (substr($rep_images, strlen($rep_images), -1) != '/') $rep_images .= '/';
$nb_requetes_sql = 0;
$start_time = gettimeofday(false);
$start_time = (float) ($start_time['sec'] + $start_time['usec'] / 1000000.0);
if ($db_link)
{
	$db_link->query('set names utf-8');
	$db_link->query('set character_set utf-8');
	$db_link->query('set character_set_results utf-8');
}

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


function load_sql($sql)
{
	global $nb_requetes_sql;
	global $db_link;
	
	prepare_sql($sql);
	$rs = $db_link->query($sql) or die($db_link->error);
	$nb_requetes_sql++;
	return $rs;
}

function load_and_fetch($sql)
{
	$rs = load_sql($sql);
	$obj = $rs->fetch_object();
	$rs->free();
	return $obj;
}

function get_option($cle, $default = '')
{
	$rs = load_and_fetch('select valeur from /*DB_PREFIX*/options where cle'.format_string_null($cle, true));
	if (!$rs->valeur)
		return $default;
	else
		return $rs->valeur;
}

?>