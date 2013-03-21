<?php

/*
 * Arttu kämälokitus tiedostoon, pitää poista ennen käyttöönottoa
 * 
 */

function logToFile($msg, $key = "", $filename = "templog.txt")
{ 
// open file
 //$date  =   date("Y-m-d H:i:s");
$fd = fopen($filename, "a");
// append date/time to message
if ($filename==="log.txt"){
    $str = "[" . date("Y/m/d h:i:s", mktime()) . "] " . $msg;
}else {
    
    $str = "[" . date("Y/m/d h:i:s", time()) . "] " . $key . ": " . $msg;
}
 
// write string

fwrite($fd, $str . "\n");
// close file
fclose($fd);
}


function logListToFile($list, $filename = "tempListlog.txt")
{ 
// open file
    
    
$fd = fopen($filename, "a");
// append date/time to message
    foreach ($list as $key => $value) {
        
    $str = $key . ": " . $value;    
    fwrite($fd, $str . "\n");
        
    }
// close file
fclose($fd);
}


?>
