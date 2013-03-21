<?php
/**
 * Suomen Frisbeeliitto Kisakone
 * Copyright 2009-2010 Kisakone projektiryhm�
 *
 * This file contains the Hole class definition.
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

class Club {
    var $id;
    var $name;
    var $short_name;
    var $region;
    var $contact;
    
    function Club($data) {
         foreach ($data as $key => $value) {
            $fieldName = core_ProduceFieldName($key);
            if ($fieldName=='name' || $fieldName=='short_name'){
               $this->$fieldName =  utf8_encode($value);
            }else {
                $this->$fieldName = utf8_encode($value);
            }
            
        }
    }
    public function getId() {
        return $this->id;
    }

    public function setId($id) {
        $this->id = $id;
    }

    public function getName() {
        return $this->name;
    }

    public function setName($name) {
        $this->name = $name;
    }

    public function getShort_name() {
        return $this->short_name;
    }

    public function setShort_name($short_name) {
        $this->short_name = $short_name;
    }

    public function getRegion() {
        return $this->region;
    }

    public function setRegion($region) {
        $this->region = $region;
    }

    public function getContact() {
        return $this->contact;
    }

    public function setContact($yhteyshenkilö) {
        $this->contact = $yhteyshenkilö;
    }


    
}
?>