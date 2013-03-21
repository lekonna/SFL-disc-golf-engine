{*
 * Suomen Frisbeeliitto Kisakone
 * Copyright 2009-2010 Kisakone projektiryhm�
 *
 * Event listing
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
 {include file='include/header.tpl'}

<h2>{$title}</h2>

{if $error}
    <p class="error">{$error}</p>

{else}
<table>
    <tr>
        <th>{sortheading field=Name id='event_name' sortType=alphabetical}</th>
        <th>{sortheading field=VenueName id='event_location' sortType=alphabetical}</th>
        <th>{sortheading field=LevelName id='event_level' sortType=alphabetical}</th>
        <th>{sortheading field=Date id='event_date' sortType=date}</th>
        <th></th>
        <th></th>        
    </tr>
   {foreach from=$events item=event}
        <tr>
            {if $event->isAccessible()}
            <td><a href="{url page="event" id=$event->id}">{$event->name|escape}</a> </td>
            {else}
            <td>{$event->name|escape}</td>
            {/if}
            <td>{$event->venue|escape}</td>
            <td>{$event->levelName|escape}</td>
            <td><input type="hidden" value="{$event->date}" />
            {$event->fulldate}</td>
            <td class="event_links">
            {if $event->resultsLocked}
                <a href="{url page='event' view=leaderboard id=$event->id}">{translate id=event_results}</a>
                            <a href="{url page='event' view=leaderboard id=$event->id}"><img src="{$url_base}ui/elements/trophyIcon.png" alt="{translate id=results_available}" /></a>
                
                {if $event->standing != null}
                    {translate id=your_standing standing=$event->standing}
                {/if}
            {elseif $event->approved !== null}
                {* There is a participation record  *}
                {if $event->approved || $event->eventFeePaid}
                    {if $event->signupState == 'accepted'}{translate id=fee_paid}{/if}
                {else}
                    {translate id=fee_not_paid} <a href="{url page=event view=payment id=$event->id}">{translate id=fee_payment_info}</a>
                {/if}
     
            {/if}
            
      
                {if $loggedon}
                    {if $event->SignupPossible()}
                        {if $event->approved !== null}
                            <a href="{url page='event' view=cancelsignup id=$event->id}">{translate id=event_cancel_signup}</a>
                        {elseif $event->waiting_number!==null}
                            <a href="{url page='event' view=cancelqueue id=$event->id}">{translate id=event_cancel_queue}</a>
                        {elseif $user->role != 'admin' && $user->role != 'manager' && $event->management != 'td'}
                        
                            <a href="{url page='event' view=signupinfo id=$event->id}">{translate id=event_signup}</a>
                            <a href="{url page='event' view=signupinfo id=$event->id}"><img src="{$url_base}ui/elements/goIcon.png" alt="{translate id=sign_up_here}" /></a>
                            
                        {/if}
                    {/if}
                    
                                       
                    {if $event->management == 'td' || $user->role == 'admin'}
                        <a href="{url page='manageevent' id=$event->id}">{translate id=event_manage}</a>
                    {/if}
                    {if ($event->management != '' || $user->role == 'admin') && $event->EventOngoing()}
                        <a href="{url page='enterresults' id=$event->id}">{translate id=event_enter_results}</a>
                    {/if}
                    {if $event->management == 'official'}
                        <a href="{url page='editnews' id=$event->id}">{translate id=event_add_news}</a>
                    {/if}
                {/if}
            </td>
        </tr>
        {foreachelse}
        <tr><td colspan="4">
            <p>{translate id=no_matching_events}</p>
        </td></tr>
    {/foreach}
</table>

{if $smarty.get.id == '' || $smarty.get.id == 'default'}
    <p><a href="{url page=events id=currentYear}">{translate id=all_current_year_events}</a></p>
{/if}

<script type="text/javascript">
//<![CDATA[
{literal}
$(document).ready(function(){
    $($(".SortHeading").get(0)).click();    
});

{/literal}


//]]>
</script>
{/if}
{include file='include/footer.tpl'}
