{**
 * Suomen Frisbeeliitto Kisakone
 * Copyright 2009-2010 Kisakone projektiryhm�
 *
 * Competitor listing
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
<div id="event_content">
    {$page->formattedText}
</div>


<form method="get" class="usersform" action="{url page=event view=competitors id=$smarty.get.id}">
    {initializeGetFormFields  search=false }
    <div class="formelements">        
         <p>{translate id=users_searchhint} </p>
        <input id="searchField" type="text" size="30" name="search" value="{$smarty.get.search|escape}" />
        <input type="submit" value="{translate id=users_search}" />
    </div>    
</form>
<hr style="clear: both;" />
<div class="SearchStatus" />

<table class="narrow" style="min-width: 400px">
   <tr>
    <th>{translate id=participant_number}</th>
    <th>{sortheading field=LastName id=lastname sortType=alphabetical}</th>
      <th>{sortheading field=FirstName id=firstname sortType=alphabetical}</th>
      <th>{sortheading field=ClassName id=class sortType=alphabetical}</th>
      <th>{sortheading field=pdga id=users_pdga sortType=integer}</th>      
      <th>{sortheading field=club id=club sortType=alphabetical}</th>
      <th>{sortheading field=Eventfee id=users_eventfees sortType=alphabetical}</th>
   </tr>

   {foreach from=$participants item=participant name=partiCip}
            
      
     <tr>
        <td>{$smarty.foreach.partiCip.index+1}</td>
        <td><a href="{url page=user id=$participant.user->username}">{$participant.user->lastname|escape}</a></td>
        <td><a href="{url page=user id=$participant.user->username}">{$participant.user->firstname|escape}</a></td>
        <td>{$participant.className|escape}</td>
         <td>{$participant.player->pdga|escape}</td>   
         <td>{$participant.player->club_id|escape}</td>   
         <td>{if $participant.eventFeePaid !== null}
             {translate id=fee} {$participant.eventFeePaid|date_format:"%d.%m.%Y %H:%M"}
             {else}
                 <span class="red">{translate id=fee_notpaid}</span>
             {/if}
         </td>        
    </tr>
   {/foreach}     
</table>

<div class="SearchStatus" />

<script type="text/javascript">
//<![CDATA[
{literal}
$(document).ready(function(){
    TableSearch(document.getElementById('searchField'), document.getElementById('userTable'),
                {/literal}"{translate id=No_Search_Results}"{literal}
                );   
    $($(".SortHeading").get(0)).click();
    
});



{/literal}


//]]>
</script>

{/if}
    {/if}