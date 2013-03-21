<?php
/**
 * Suomen Frisbeeliitto Kisakone
 * Copyright 2009-2010 Kisakone projektiryhm�
 *
 * This file includes the Classification class, which represents a single
 * classification in the system.
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


class Classification
{
    var $id;
    var $name;
    var $minAge;
    var $maxAge;
    var $gender;
    var $available;
    var $class_player_limit;
    var $openPositions;
    
    /** ************************************************************************
     * Class constructor
     */
    function Classification($id = null, $name = null, $minAge = 0, $maxAge = 0, $gender = null, $available = 0, $class_player_limit=0, $openPositions = null)
    {
      if (is_array($id)) {
        $this->initializeFromArray($id);

      }  else {
        $this->id = $id;
        $this->name = $name;
        $this->minAge = $minAge;
        $this->maxAge = $maxAge;
        $this->gender = $gender;
        $this->available = $available;
        $this->class_player_limit = $class_player_limit;
        $this->openPositions = $openPositions;        
      }
      
      
    }
    
    function initializeFromArray($array) {
        $this->id = $array['id'];
        $this->name = $array['Name'];
        $this->minAge = $array['MinimumAge'];
        $this->maxAge = $array['MaximumAge'];
        $this->gender = $array['GenderRequirement'];
        $this->available = $array['Available'];
        $this->class_player_limit = $array['ClassPlayerLimit'];
    }
    
    function getPlayers($event = null) {
        static $data;
        if ($data) return $data;
        
       
        $data = GetSignupsForClass($event, $this->id);
        
        return $data;
    }
   
    
  
}
?>