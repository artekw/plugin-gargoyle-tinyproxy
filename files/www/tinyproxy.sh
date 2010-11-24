#!/usr/bin/haserl
<?
	# Copyright (c)  2010 Artur Wronowski <arteqw@gmail.com> 
	eval $( gargoyle_session_validator -c "$COOKIE_hash" -e "$COOKIE_exp" -a "$HTTP_USER_AGENT" -i "$REMOTE_ADDR" -r "login.sh" -t $(uci get gargoyle.global.session_timeout) -b "$COOKIE_browser_time"  )
	gargoyle_header_footer -h -s "connection" -p "tinyproxy" -c "internal.css" -j "tinyproxy.js" tinyproxy network
?>

<script>
<!--
<?

   echo "var filterurl_file = new Array();"
   if [ -e /etc/tinyproxy/filter ]; then 
      cat /etc/tinyproxy/filter | awk '{print "filterurl_file.push([\""$1"\"]);"};'
  fi	


?>
//-->
</script>

<fieldset id="tinyproxy">
	<legend class="sectionheader">Tinyproxy</legend>
		<div id='tinyproxy_enabled_container' class='rightcolumn'>
		<label id='tinyproxy_enabled_label' class='leftcolumn'>Tinyproxy</label>
			<select class="rightcolumn" id="tinyproxy_enabled" onchange="setVisibilityTinyproxy()">
				<option value="1">Enabled</option>
				<option value="0">Disabled</option>
			</select>
		</div>

	<div id="tinyproxy_container">
		<div id='tinyproxy_transp_container'>
		   <label id="tinyproxy_transp_label" class="leftcolumn" for="tinyproxy_transparent">Transparent proxy:</label>
		      <select class="rightcolumn" id="tinyproxy_transparent">
                                <option value="1">Enabled</option>
                                <option value="0">Disabled</option>
              </select>
		</div>
		
        <div id='tinyproxy_filterurl_container' class='rightcolumn'>
            <label id='tinyproxy_filterurl_label' class='leftcolumn'>Filter URL</label>
               <select class="rightcolumn" id="tinyproxy_filterurl" onchange="setVisibilityFilterURL()">
                                <option value="On">Enabled</option>
                                <option value="Off">Disabled</option>
               </select>
        </div>
		
		<div id='tinyproxy_filterurledit_container'>
                        <label id="tinyproxy_filterurledit_label" class="leftcolumn" for="tinyproxy_filterurledit">Filter URL Content:</label>
                        <textarea id="tinyproxy_filterurledit" class="rightcolumn" rows='4' cols='30'/></textarea>
                </div>

                <div id='tinyproxy_startservers_container'>
		<label id='tinyproxy_startservers_label' class='leftcolumn'>Start Servers</label>
                        <select class="rightcolumn" id="tinyproxy_startservers">
                                <option value="1">1</option>
                                <option value="2">2</option>
				<option value="3">3</option>
				<option value="4">4</option>
				<option value="5">5</option>
				<option value="6">6</option>
				<option value="7">7</option>
				<option value="8">8</option>
				<option value="9">9</option>
				<option value="10">10</option>
                        </select>

                </div>

		<div id='tinyproxy_port_container'>
			<label id="tinyproxy_port_label" class="leftcolumn" for="tinyproxy_port">Proxy port:</label>
                	<input id="tinyproxy_port" class="rightcolumn" type=text" size='5'/>
		</div>

                <div id='tinyproxy_allowips_container'>
                        <label id="tinyproxy_allowips_label" class="leftcolumn" for="tinyproxy_allowips">Allow IPs:</label>
                        <input id="tinyproxy_allowips" class="rightcolumn" type=text" size='17'/>
                </div>

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

        <br />
        <div>
             <em>WARNING: Be careful with too large value of the Start Servers on routers with a small amount of RAM memory.
             The default value is 10. The recommended process is 2-3.
             Log Level: Critical (least verbose), Connect (log connections without Info's noise), Info (most verbose).</em>
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
	gargoyle_header_footer -f -s "connection" -p "tinyproxy"
?>
