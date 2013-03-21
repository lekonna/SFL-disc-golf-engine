<?php
/** Kisakone configuration settings
 * Generated automatically on 2010-02-15 15:54:42
 * The file itself is in the public domain */
global $settings;
define('DEV_ENVIRONMENT', true);
if (DEV_ENVIRONMENT==true) {
    //ini_set('display_errors', '0');     # don't show any errors...
    //error_reporting(E_ALL | E_STRICT);  # log all
    $settings['DB_ADDRESS'] = 'localhost';
    $settings['DB_DB'] = "kisakone";
    $settings['DB_USERNAME'] = "root";
    $settings['DB_PASSWORD'] = "";
    $settings['DB_PREFIX'] = "kisakone_";
} else {
    $settings['DB_ADDRESS'] = '';
    $settings['DB_DB'] = "";
    $settings['DB_USERNAME'] = "";
    $settings['DB_PASSWORD'] = "";
    $settings['DB_PREFIX'] = "kisakone_";
    
}

$settings['USE_MOD_REWRITE'] = false;

include_once('config_email.php');        
require_once('FirePHPCore/FirePHP.class.php');   
require_once('core/log/log.php');   
 
 ?>