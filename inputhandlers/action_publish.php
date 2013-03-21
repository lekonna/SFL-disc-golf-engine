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

function ProcessAction() {
    language_include('events');
    $event = GetEventDetails(@$_GET['id']);
    //if ($event->resultsLocked) return Error::AccessDenied();
    if (!$event) return Error::NotFound('event');
    
    if (!IsAdmin() && $event->management == '') return Error::AccessDenied();
    $view = @$_GET['view'];
    if ($view==''){
        $view='index';
    }
    if (empty($view) || $view=="")  return Error::AccessDenied();
    
    $cmd = @$_GET['cmd'];
    if (empty($cmd) || $cmd=="")  return Error::AccessDenied();
        
    if (!ChangePagePublicity($event, $view, $cmd)){
        return Error::AccessDenied();
    }
            
   if ($view=='index'){
       $view = '';
   }
    header("Location: " . url_smarty(array('page' => 'event', 'id' => $event->id, 'view'=>$view), $_GET));
    //return translate('saved', array('time' => date('H:i:s')));
    //return $playerid;
}

?>