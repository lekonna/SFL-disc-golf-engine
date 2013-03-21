<?php

/**
 * Suomen Frisbeeliitto Kisakone
 * Copyright 2009-2010 Kisakone projektiryhm�
 *
 * This file is the backend for doing form validation using AJAX
 * 
 * --
 *
 * This file is part of Kisakone.
 * Kisakone is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Kisakone is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License
 * along with Kisakone.  If not, see <http://www.gnu.org/licenses/>.
 * */

/**
 * Initializes the variables and other data necessary for showing the matching template
 * @param Smarty $smarty Reference to the smarty object being initialized
 * @param Error $error If input processor encountered a minor error, it will be present here
 */
function InitializeSmartyVariables(&$smarty, $error) {
    language_include('formvalidation');
    $keissi = $_GET['id'];
    switch ($keissi) {
        case "username":
            // Ensure username is valid
            if (!preg_match('/^[\pL\d_-]+$/', $_GET['username'])) {
                $data = translate('FormError_InvalidUsername', array('username' => htmlentities($_GET['username'])));
            } else if (GetUserId($_GET['username']) !== null) {
                $data = translate('FormError_DuplicateUsername', array('username' => htmlentities($_GET['username'])));
            } else {
                $data = 'OK';
            }


            break;
        case 'validuser':

            $username = @$_GET['username'];

            $td = input_GetUser($username);

            if (!$td)
                $data = translate('FormError_InvalidUsername', array('username' => $username));
            else
                $data = 'OK';

            break;
            
        case 'pdga':

            $pdga = @$_GET['pdga'];

            //$td = input_GetUser($username);

            
            $data = fetchUserInfoFromSfl($pdga);
           
            logListToFile($data);
            
            echo json_encode($data);
             //$smarty->assign('data', json_encode($data));

            break;
            
        default:
            $data = 'InvalidOperation';
    }
    if ($_GET['id']!='pdga')
    $smarty->assign('data', $data);

    SetContentType("text/plain");
}

/**
 * Determines which main menu option this page falls under.
 *
 * This function is required by the interface, alhtough this page doesn't have
 * the menu.
 * @return String token of the main menu item text.
 */
function getMainMenuSelection() {
    return 'index';
}

?>
