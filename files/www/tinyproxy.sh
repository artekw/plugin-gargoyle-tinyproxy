#!/usr/bin/haserl
<?
	# This program is copyright © 2010 Artur Wronowski <arteqw@gmail.com> and is distributed under the terms of the GNU GPL 
	# version 2.0 with a special clarification/exception that permits adapting the program to 
	# configure proprietary "back end" software provided that all modifications to the web interface
	# itself remain covered by the GPL. 
	# See http://gargoyle-router.com/faq.html#qfoss for more information
	eval $( gargoyle_session_validator -c "$COOKIE_hash" -e "$COOKIE_exp" -a "$HTTP_USER_AGENT" -i "$REMOTE_ADDR" -r "login.sh" -t $(uci get gargoyle.global.session_timeout) -b "$COOKIE_browser_time"  )
	gargoyle_header_footer -h -s "system" -p "tinyproxy" -c "internal.css" -j "tinyproxy.js" tinyproxy

?>

<script>
<!--
<?
	
?>
//-->
</script>

<fieldset id="tinyproxy">
	<legend class="sectionheader">Tinyproxy</legend>
		<div id='tinyproxy_enabled_container' class='rightcolumn'>
		<label id='tinyproxy_enabled_label' class='leftcolumn'>Tinyproxy</label>
			<select class="rightcolumn" id="tinyproxy_enabled" onchange="setVisibility()">
				<option value="1">Enabled</option>
				<option value="0">Disabled</option>
			</select>
		</div>

	<div id="tinyproxy_container">
<!--
		<div id='tinyproxy_transp_container'>
		<label id="tinyproxy_transp_label" class="leftcolumn" for="tinyproxy_transp">Transparent proxy:</label>
		<select class="rightcolumn" id="tinyproxy_transp">
                                <option value="enable">Enabled</option>
                                <option value="disable">Disabled</option>
                </select>
		</div>
-->
		<div id='tinyproxy_port_container'>
			<label id="tinyproxy_port_label" class="leftcolumn" for="tinyproxy_port">Proxy port:</label>
                	<input id="tinyproxy_port" class="rightcolumn" type=text" size='5'/>
		</div>
<!--
		<div id='tinyproxy_allow_access_container'>
                        <label id="tinyproxy_allowaccess_label" class="leftcolumn" for="tinyproxy_port">Allow access from:</label>
                        <input id="tinyproxy_allowaccess" class="rightcolumn" type=text" size='5'/>
                </div>
-->
		<div id='tinyproxy_loglevel_container'>
                        <label id="tinyproxy_loglevel_label" class="leftcolumn" for="tinyproxy_port">Log level:</label>
                        <select class="rightcolumn" id="tinyproxy_loglevel">
                                <option value="Critical">Critical</option>
                                <option value="Error">Error</option>
				<option value="Warning">Warning</option>
				<option value="Notice">Notice</option>
				<option value="Connect">Connect</option>
				<option value="Info">Info</option>
                </select>

                </div>


	</div>
	

<div id="bottom_button_container">
	<input type='button' value='Save Changes' id="save_button" class="bottom_button" onclick='saveChanges()' />
	<input type='button' value='Reset' id="reset_button" class="bottom_button" onclick='resetData()'/>
</div>



<!-- <br /><textarea style="margin-left:20px;" rows=30 cols=60 id='output'></textarea> -->

<script>
<!--
	resetData();
//-->
</script>


<?
	gargoyle_header_footer -f -s "system" -p "tinyproxy"
?>
