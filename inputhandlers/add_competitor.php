<?php

/**
 * Suomen Frisbeeliitto Kisakone
 * Copyright 2009-2010 Kisakone projektiryhm�
 *
 * This file is the handler for "add competitor" form
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
 * Processes the form
 * @return Nothing or Error object on error
 */
function processForm() {
    $problems = array();
    require_once('core/event_management.php');
    require_once('core/user_operations.php');

    $event = GetEventDetails(@$_GET['id']);
    if (!IsAdmin() && $event->management != 'td')
        return Error::AccessDenied('addcompetitor');

    if ($event->resultsLocked)
        return Error::AccessDenied();

    if (@$_POST['cancel']) {

        $empty = null;
        header("Location: " . url_smarty(array('page' => 'addcompetitor', 'id' => @$_GET['id']), $empty));
        die();
    }

    if (@$_GET['user'] != 'new') {
        // Simply selecting a user, not creating a new one
        if (PlayerParticipating($_GET['id'], $_GET['user'])) {
            return translate("player_already_participating");
        }
        $u = GetUserDetails($_GET['user']);
        $player = $u->GetPlayer();
        $class = GetClassDetails($_POST['class']);
        $requiredFees = $event->FeesRequired();
        if (!$player->IsSuitableClass($class)) {
            return translate("error_invalid_class");
        }
        if (!$u->FeesPaidForYear(date('Y', $event->startdate), $requiredFees)) {
            $message = "";
            if ($requiredFees > 0) {
                $temp = translate("membership_required");
                $message .= $temp . "<br />";
            }
            if ($requiredFees == 2 || $requiredFees == 3) {
                $temp = translate("licence_b_requiered");
                $message .= $temp . "<br />";
            }
            if ($requiredFees == 6 || $requiredFees == 7) {
                $temp = translate("licence_a_requiered");
                $message .= $temp . "<br />";
            }
            return $message;
        }

        $retVal = SignupUser($_GET['id'], $_GET['user'], $_POST['class']);
        if (is_a($retVal, 'Error'))
            return $retVal;
        header("Location: " . url_smarty(array('page' => 'addcompetitor', 'id' => @$_GET['id']), $_GET));
        die();
    } else {



        $lastname = $_POST['lastname'];
        if ($lastname == '')
            $problems['lastname'] = translate('FormError_NotEmpty');

        $firstname = $_POST['firstname'];
        if ($firstname == '')
            $problems['firstname'] = translate('FormError_NotEmpty');

        $email = $_POST['email'];
        if (!preg_match('/^.+@.+\..+$/', $email))
            $problems['email'] = translate('FormError_InvalidEmail');

        $pdga = $_POST['pdga'];
        if ($pdga == '')
            $pdga = null;
        else {
            $num = (int) $pdga;
            if ($num <= 0)
                $problems['pdga'] = translate('FormError_PDGA');
        }

        $gender = @$_POST['gender'];
        if ($gender != 'male' && $gender != 'female')
            $problems['gender'] = translate('FormError_NotEmpty');

        $dobYear = $_POST['dob_Year'];

        if ($dobYear != (int) $dobYear)
            $problems['dob'] = translate('FormError_NotEmpty');

        $class = (int) @$_POST['class'];


        if (count($problems)) {

            $error = new Error();
            $error->title = 'Add_Competitor form error';
            $error->function = 'InputProcessing:Add_Competitor:processForm';
            $error->cause = array_keys($problems);
            $error->data = $problems;
            return $error;
        }
    }



    $u = RegisterPlayer(null, null, $email, $firstname, $lastname, $gender, $pdga, $dobYear);


    if (is_a($u, 'Error'))
        return $u;

    $player = $u->GetPlayer();
    $classobj = GetClassDetails($_POST['class']);

    if (!$player->IsSuitableClass($classobj)) {
        return translate("error_invalid_class");
    }





    $retVal = SignupUser(@$_GET['id'], $u->id, $class);
    if (is_a($retVal, 'Error'))
        return $retVal;

    header("Location: " . url_smarty(array('page' => 'addcompetitor', 'id' => @$_GET['id']), $_GET));
}

?>
