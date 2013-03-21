{*
 * Suomen Frisbeeliitto Kisakone
 * Copyright 2009-2010 Kisakone projektiryhm�
 *
 * Layout before content
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
 * *}
<!DOCTYPE html 
     PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
     "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
      <title>{$title} - {translate id=site_name}</title>
      <link rel="stylesheet" href="{$url_base}ui/elements/style.css" type="text/css" />
      <script type="text/javascript" src="{$url_base}ui/elements/jquery-1.3.2.min.js"></script>      
      <script type="text/javascript" src="{$url_base}javascript/base"></script>
      {if $autocomplete}
      <script type="text/javascript" src="{$url_base}ui/elements/jquery.autocomplete-min.js"></script>
      {/if}
      {if $ui}
      <script type="text/javascript" src="{$url_base}ui/elements/jquery-ui-1.7.2.custom.min.js"></script>
      <link rel="stylesheet" href="{$url_base}ui/elements/jquery-ui-1.7.2.custom.css" type="text/css" />
      <meta http-equiv="Content-Type" content="{$contentType}" />
      {/if}
      {$extrahead}
</head>
<body>
<table id="contentcontainer">
      <tr id="headtr">
            <td colspan="3">
            
      <div id="header">
      {include file="include/loginbox.tpl"}
      {if $smarty.get.languagebar }
            {* Disabled from normal use as we only have a single language *}
            {include file='include/languagebar.tpl'}
      {/if}
      <img id="sitelogo" src="{$url_base}ui/elements/logo2.png" alt="{translate id=site_name}" />
      
      <h1 id="sitename">{translate id=site_name_long}</h1>
      <div id="pagename">{$title}</div>
      </div>
      {include file="include/mainmenu.tpl"}
            </td></tr>
    <tr id="maintr2">
        <td id="submenucontainer">        <br />
            {$submenu_content}
            
            {include file="include/submenu.tpl"}
        </td>        
        <td id="content">
            <ul class="breadcrumb">
                  {if $mainmenuselection != 'unique'}
                        {include file="include/breadcrumb.tpl" from=$submenu.$mainmenuselection}
                  {else}
                        <li>{$title}</li>
                  {/if}
            </ul>
            <br style="clear: left" />

