<?php

/*
 * Suomen Frisbeeliitto Kisakone
 * Copyright 2009-2010 Kisakone projektiryhm�
 *
 * Stores an entered result
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

//fill_open_positions
function ProcessAction() {
    language_include('events');
    $event = GetEventDetails(@$_GET['id']);
    //if ($event->resultsLocked) return Error::AccessDenied();
    if (!$event)
        return Error::NotFound('event');

    if (!IsAdmin() && $event->management == '')
        return Error::AccessDenied();
$success = FillOpenPositionsFromQueue($event);
    if ($success!='') {
        $view = 'waitinglist';
        return translate($success);
    }/*else {
        $view = 'waitinglist';
        return Error::AccessDenied();
        
    }
     * 
     */
    $view = 'competitors';
    /*
    
    $classes = $event->GetClasses();
    foreach ($classes as $class) {
        //$classificationPlayerCount = GetClassificationPlayerCount($event->id, $class->id);
        //$openPos = $class->class_player_limit - $classificationPlayerCount;
    }
    */
    //$classificationPlayerCount = GetClassificationPlayerCount($event, $class->id);
    //$openPos = $class->class_player_limit - $classificationPlayerCount;
  
    header("Location: " . url_smarty(array('page' => 'event', 'id' => $event->id, 'view' => $view), $_GET));
    //return translate('saved', array('time' => date('H:i:s')));
    //return $playerid;
}

?>