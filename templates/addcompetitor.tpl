{**
 * Suomen Frisbeeliitto Kisakone
 * Copyright 2009-2010 Kisakone projektiryhm�
 *
 * This file is the UI for adding competitors to an event
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
{translate id='addcompetitor_title' assign='title'}
{include file='include/header.tpl' autocomplete=1}

{include file=support/eventlockhelper.tpl}

{if $errorString}<p class="error">{$errorString}</p>{/if}

{if !$userdata && !is_array($many)}
    {* We have neither an user, nor a listing *}
    <p>{translate id=add_competitor_help}</p>
    <form method="get">
        {initializeGetFormFields  search=false}
        <label>{translate id=add_competitor_prompt}</label>
        <input id="player" type="text" size="40" name="player" />
        <input name="op_s"  type="submit" value="{translate id=search}" />
    </form>
    
    <p>
        <a href="{url page=addcompetitor id=$smarty.get.id user=new}">{translate id=add_competitor_create_new}</a>
    </p>
    
    <script type="text/javascript">
//<![CDATA[
{literal}
$(document).ready(function(){
   var options, a;
    // Initialize autocomplete
    options = { serviceUrl: baseUrl ,
                params: {path: 'autocomplete', 'id': 'players' }};
    a = $('#player').autocomplete(options);
    
    
});

{/literal}

//]]>
</script>
    
    
{elseif is_array($many)}
    {* Listing of users *}
    <p>{translate id=add_competitor_list_help}</p>
    <table class="oddrows">
        {foreach from=$many item=user}
            {assign var=player value=$user->getPlayer()}
            <tr>
                <td><a href="{url page=addcompetitor id=$smarty.get.id user=$user->id}">{translate id=select}</a></td>
                <td>{$player->pdga|escape}</td>
                <td>{$user->fullname | escape}</td>
                
                <td>
                    {if $user->username}
                        {$user->username|escape}
                    {else}
                        {translate id=add_competitor_no_username}                    
                    {/if}
                    
                </td>
            </tr>
        
        {foreachelse}
            <tr><td>{translate id=add_competitor_nomatch}</td></tr>
        {/foreach}
    </table>
    
    <p>
        <a href="{url page=addcompetitor id=$smarty.get.id user=new}">{translate id=add_competitor_create_new}</a>
    </p>

{else}
    {* User details *}
<form method="post" class="evenform" id="regform">
    {assign var=player value=$userdata->getPlayer()}
    <input type="hidden" name="userid" value="{$user->id}" />
    <input type="hidden" name="formid" value="add_competitor" />
    
    <h2>{translate id='reg_contact_info'}</h2>    
    
    <div>
        <label  for="lastname">{translate id='last_name'}</label>
        <input id="lastname" {if !$edit}disabled="disabled"{/if} type="text" name="lastname" value="{$userdata->lastname|escape}" />
        {formerror field='lastname'}
    </div>
    <div>
        <label for="firstname">{translate id='first_name'}</label>
        <input type="text" id="firstname" name="firstname" {if !$edit}disabled="disabled"{/if}  value="{$userdata->firstname|escape}" />
        {formerror field='firstname'}
    </div>
    <div>
        <label for="email">{translate id='reg_email'}</label>
        <input id="email" {if !$edit}disabled="disabled"{/if} type="text" name="email"  value="{$userdata->email|escape}" />
        {formerror field='email'}
    </div>
    
    {if $userdata->id}
    <h2>{translate id='reg_user_info'}</h2>
    <div>
        <label for="username">{translate id='username'}</label>
        <input id="username" {if !$edit}disabled="disabled"{/if} type="text" name="username"  value="{$userdata->username|escape}" />
        {formerror field='username'}
    </div>
    {/if}

    
    <h2>{translate id='reg_player_info'}</h2>
     <div>
        <label for="pdga">{translate id='pdga_number'}</label>
        <input id="pdga" type="text" {if !$edit}disabled="disabled"{/if} name="pdga"  value="{$player->pdga|escape}" />
        {formerror field='pdga'}
    </div>
     
     <div>
        <label for="gender">{translate id='gender'}</label>
        <input id="gender" type="radio" {if !$edit}disabled="disabled"{/if} {if $player->gender == 'M'}checked="checked"{/if} name="gender" value="male" /> {translate id="male"} &nbsp;&nbsp;
        <input type="radio" {if !$edit}disabled="disabled"{/if} {if $player->gender == 'F'}checked="checked"{/if} name="gender" value="female" /> {translate id="female"}
        
    </div>
     
     
     <div style="margin-top: 8px">
        <label>{translate id='dob'}</label>


        {translate id='year_default' assign='year_default'}
        {if $edit}
        {html_select_date time=0-0-0 field_order=DMY month_format=%m 
        prefix='dob_' start_year='1900' display_months=false display_days=false year_empty=$year_default month_empty=$month_default day_empty=$day_default field_separator=" "
        all_extra='style="min-width: 0"' }
        {else}
        <input type="text" value="{$player->birthyear|escape}" disabled="disabled" />
        {/if}
        
        {formerror field='dob'}
    </div>
     
     <h2>{translate id='add_competitor_class'}</h2>
     <div>
        
        <label for="class">{translate id='class'}</label>
        
        <select id="class" name="class">
            {html_options options=$classOptions}
        </select>
        
        {formerror field='class'}
     </div>
    
   
    
    <h2>{translate id='reg_finalize'}</h2>
    <div>
        <input type="submit" value="{translate id='form_accept'}" name="accept" />
        <input type="submit" id="cancelButton" value="{translate id='form_cancel'}" name="cancel" />
        
        
    </div>
</form>

<script type="text/javascript">
//<![CDATA[
{literal}
$(document).ready(function(){
    CheckedFormField('regform', 'lastname', NonEmptyField, null);
    CheckedFormField('regform', 'firstname', NonEmptyField, null);
    CheckedFormField('regform', 'email', EmailField, null);    

    CheckedFormField('regform', 'gender', RadioFieldSet, null);
    CheckedFormField('regform', 'dob_Year', NonEmptyField, null);
    
    
    $("#cancelButton").click(CancelSubmit);
    
});

{/literal}


//]]>
</script>

{/if}

{include file='include/footer.tpl'}
