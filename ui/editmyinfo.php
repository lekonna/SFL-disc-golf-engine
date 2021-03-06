<?php
/**
 * Suomen Frisbeeliitto Kisakone
 * Copyright 2009-2010 Kisakone projektiryhm§
 *
 * User info editor
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
   
   
   if ($error) {
        $smarty->assign('error', $error->data);
        $user = new User();
        $player = new Player();
        $user->firstname = $_POST['firstname'];
        $user->lastname = $_POST['lastname'];
        $player->birthyear = $_POST['dob_Year'];
        $player->pdga = $_POST['pdga'];
        $user->email = $_POST['email'];
        $player->gender = $_POST['gender'];
   } else {
         if (@$_GET['id']) {
            if (!IsAdmin()) return Error::AccessDenied();
            
            $getId = $_GET['id'];
            if (is_numeric($getId)) $userid= $getId;
            else $userid = GetUserId($getId);
   
             $user = GetUserDetails($userid);
             
             
             
         } else {
            $user = @$_SESSION['user'];
         }
         $player = $user->GetPlayer();
   }
   

   
   $smarty->assign('userdata', $user);
   $smarty->assign('player', $player);
   if ($player) $smarty->assign('dob', $player->birthyear . '-1-1');    
}



/**
 * Determines which main menu option this page falls under.
 * @return String token of the main menu item text.
 */
function getMainMenuSelection() {
    return 'users';
}
?>
