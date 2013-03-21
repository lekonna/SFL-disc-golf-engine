{**
 * Suomen Frisbeeliitto Kisakone
 * Copyright 2009-2010 Kisakone projektiryhm�
 *
 * Event schedule
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
 {if $admin || $visibility=='public'} 
 {if $mode != 'body'}
      
 <style type="text/css">{literal}
.selected td {
    background-color: #DFD;
}
{/literal}</style>
{else}
 <div id="event_content">
    {$page->formattedText}
</div>



{if !$smarty.get.round}
    {foreach from=$rounds key=index item=round}    
        {math assign=num equation="x+1" x=$index}
        <h3>{translate id=round_title number=$num}</h3>
        <div>{$round->starttime|date_format:"%d.%m.%Y"}</div>
        {capture assign=start}{$round->starttime|date_format:"%H:%M"}{/capture}
        {if $round->starttype == 'sequential'}            
            <p>{translate id=sequential_start time=$start}</p>
        {elseif $round->starttype == 'simultaneous'}
            <p>{translate id=simultaneous_start time=$start}</p>
        {/if}
        {if $round->groupsAvailable()}
            {assign var=group value=$round->GetUserGroup()}
            {if $group}
                <p>{translate id=your_group} {if $round->groupsFinished === null}{translate id=preliminary}{/if}</p>
                <p style="float: left; margin: 8px;">
                {if $round->starttype == 'simultaneous'}{translate id=your_group_starting_hole hole=$group.0.StartingHole}
                  {else}
                  {$group.0.StartingTime|date_format:"%H:%M"}
                  {/if}</p>
                <table class="narrow">
                {foreach from=$group item=player}
                    <tr>
          
                        <td>
                            {$player.LastName|escape} {$player.FirstName|escape}
                        </td>
                        <td>
                            {$player.ClassificationName}    
                        </td>
                    </tr>
                {/foreach}
                </table>
                {if $allow_print}<p><a href="{url page=printscorecard id=$smarty.get.id round=$smarty.get.round}">{translate id=print_score_card}</a></p>{/if}
            {/if}
            <p>
                <a href="{url page=event id=$smarty.get.id view=schedule round=$num}">{translate id=view_group_list}</a>
                {if $round->groupsFinished === null}
                    {translate id=groups_not_finished}
                {/if}
            </p>
        {/if}
        <hr />
    {/foreach}
{else}
{math assign=num equation="x-1" x=$smarty.get.round}
 {assign var=round value=$rounds.$num}    
    <h3>{translate id=round_title number=$smarty.get.round}</h3>
    {if $allow_print}<p><a href="{url page=printscorecard id=$smarty.get.id round=$smarty.get.round}">{translate id=print_score_card}</a></p>{/if}
    <table>
        {assign var=lastGroup value=-1}
        {foreach from=$round->GetAllGroups() item=group}
            {if $group.PoolNumber != $lastGroup}
                {assign var=lastGroup value=$group.PoolNumber}
                <tr><td>&nbsp;</td></tr>
            {/if}
            
            {if $group.UserId == $user->id}
            <tr class="selected">
            { else}
            <tr>
                {/if}
                <td>{$group.PoolNumber}</td>
                <td>
                    {if $round->starttype == 'simultaneous'}
                    {translate id=your_group_starting_hole hole=$group.StartingHole}
                    {else}
                    {$group.StartingTime|date_format:"%H:%M"}
                    {/if}
                </td>
                <td>
                    {$group.LastName|escape} {$group.FirstName|escape}
                </td>
                <td>
                    {$group.ClassificationName}    
                </td>
            </tr>            
        {/foreach}
    </table>
    {if $allow_print}<p><a href="{url page=printscorecard id=$smarty.get.id round=$smarty.get.round}">{translate id=print_score_card}</p>{/if}
{/if}
{/if}
    {/if}