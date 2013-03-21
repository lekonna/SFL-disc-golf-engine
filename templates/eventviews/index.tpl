{**
 * Suomen Frisbeeliitto Kisakone
 * Copyright 2009-2010 Kisakone projektiryhm�
 *
 * Event main page
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
{if $mode == 'body'}
    {if $admin || $visibility=='public'}    
        
        {*
        {if  $visibility=='private'}
            {assign var=private value="private_visibility"}
          
        {/if}
        *}
        <div id="event_content" class="{$private}">
            {$page->formattedText}    
        </div>

        <table class="narrow">
            <tr>
                <td>{translate id=event_name}</td>
                <td>{$event->name|escape}</td>
            </tr>

            <tr>
                <td>{translate id=event_venue}</td>
                <td>{$event->venue|escape}</td>
            </tr>

            <tr>
                <td>{translate id=event_date}</td>
                <td>{$event->fulldate|escape}</td>
            </tr>

            <tr>
                <td>{translate id=event_level}</td>
                <td>{$event->level|escape}</td>
            </tr>

            <tr>
                <td>{translate id=event_tournament}</td>
                <td>{$event->tournament|escape}</td>
            </tr>
            <tr>
                <td>{translate id=event_contact}</td>
                <td id="contactInfo"><div style="font-family: monospace">{$contactInfoHTML}</div></td>        
            </tr>




        </table>

        <h2>{translate id=schedule}</h2>

        {$index_schedule_text}

        <table>
            <tr>
                <th>{translate id=round_number number=''}</th>
                <th>{translate id=round_starttime}</th>
                {if $groups}
                    <th>{translate id=your_group_is}</th>    
                {/if}
            </tr>
            {foreach from=$rounds item=round key=index}

                <tr>
                    {math assign=number equation="x+1" x=$index}
                    <td>{translate id=round_number number=$number}</td>
                    <td>{$round->starttime|date_format:"%d.%m.%Y %H:%M"}</td>

                    {assign var=group value=$groups.$index}
                    {if $group}
                        <td>
                            {if $round->starttype=='sequential'}
                            {capture assign=groupstart}{$group.StartingTime|date_format:"%H:%M"}{/capture}
                            {translate id=your_group_starting start=$groupstart}
                        {if $round->groupsFinished === null}{translate id=preliminary}{/if}
                {else}{translate id=your_group_starting_hole hole=$group.StartingHole}{/if}
            </td>
        {/if}

    </tr>
{/foreach}

</table>

<p><a href="{url page=event id=$smarty.get.id view=schedule}">{translate id=full_schedule}</a></p>

<h2>{translate id=relevant_news}</h2>

{foreach from=$news item=item}
    {include file='eventviews/newsitem.tpl' item=$item}
{/foreach}

{if count($news)}
    <p><a href="{url page=event id=$smarty.get.id view=newsarchive}">{translate id=news_archive}</a></p>
{else}
    <p>{translate id=no_news}</p>
{/if}


<script type="text/javascript">
    //<![CDATA[
    var ci = new Array();
    {$contactInfoJS}

    {literal}

function getContactInfo() {
    var str = '';
    
    
    for (var i = 0; i < ci.length; ++i) {
        str += ci[i];
    }

    return str;
}

$(document).ready(function(){
    
    $("#contactInfo").empty();
    $("#contactInfo").get(0).appendChild(document.createTextNode(getContactInfo()));
});



    {/literal}


        //]]>
</script>

{/if}
{/if}