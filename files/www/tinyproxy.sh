#!/usr/bin/haserl
<?
	# Copyright (c)  2010-2011 Artur Wronowski <arteqw@gmail.com>
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
		<div id='tinyproxy_enable_container' class='rightcolumn'>
		<label id='tinyproxy_enable_label' class='leftcolumn'>Tinyproxy</label>
			<select class="rightcolumn" id="tinyproxy_enable" onchange="setVisibilityTinyproxy()">
				<option value="1">Włączone</option>
				<option value="0">Wyłączone</option>
			</select>
		</div>

	<div id="tinyproxy_container">
		<div id='tinyproxy_transp_container'>
		   <label id="tinyproxy_transp_label" class="leftcolumn" for="tinyproxy_transparent">Przezroczyste proxy:</label>
		      <select class="rightcolumn" id="tinyproxy_transparent">
                                <option value="1">Włączone</option>
                                <option value="0">Wyłączone</option>
              </select>
		</div>

        <div id='tinyproxy_filterurl_container' class='rightcolumn'>
            <label id='tinyproxy_filterurl_label' class='leftcolumn'>Filtrowanie treści:</label>
               <select class="rightcolumn" id="tinyproxy_filterurl" onchange="setVisibilityFilterURL()">
                                <option value="On">Włączone</option>
                                <option value="Off">Wyłączone</option>
               </select>
        </div>

		<div id='tinyproxy_filterurledit_container'>
                        <label id="tinyproxy_filterurledit_label" class="leftcolumn" for="tinyproxy_filterurledit">Zawartość filtra:</label>
                        <textarea id="tinyproxy_filterurledit" class="nocolumn" rows='4' cols='30'/></textarea>
        </div>

                <div id='tinyproxy_startservers_container'>
		<label id='tinyproxy_startservers_label' class='leftcolumn'>Ilość procesów programu:</label>
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
			<label id="tinyproxy_port_label" class="leftcolumn" for="tinyproxy_port">Port serwera proxy:</label>
                	<input id="tinyproxy_port" class="rightcolumn" type="text" size="5"/>
		</div>

                <div id='tinyproxy_allowips_container'>
                        <label id="tinyproxy_allowips_label" class="leftcolumn" for="tinyproxy_allowips">Dozwolone adresy IP:</label>
							<select class="rightcolumn" id="tinyproxy_allowips" onchange="setVisibilityAllowIP()">
								<option value="all">Cała sieć</option>
								<option value="custom">Własne</option>
							</select>
				</div>

				<div id='tinyproxy_allowipedit_container'>
                        <label id="tinyproxy_allowipedit_label" class="leftcolumn" for="tinyproxy_allowipdit">Własne IP:</label>
                        <input id="tinyproxy_allowipedit" class="nocolumn" type="text" size='17'/>
                </div>

		<div id='tinyproxy_loglevel_container'>
                        <label id="tinyproxy_loglevel_label" class="leftcolumn" for="tinyproxy_port">Poziom logowania:</label>
                        <select class="rightcolumn" id="tinyproxy_loglevel">
                                <option value="Critical">Tylko krytyczne</option>
                                <option value="Error">Błędy programu</option>
				<option value="Warning">Ostrzeżenia programu</option>
				<option value="Notice">Informacje programu</option>
				<option value="Connect">Nawiązanie połączenia</option>
				<option value="Info">Wszystko</option>
                </select>
		</div>

		<div class='rightcolum' style="margin-bottom:15px">
			<input type='button' id="tinyproxy_logview_button" value="Pokaż log" class="default_button" onclick="showLog()" />
		</div>
        <div>
             <em>UWAGA: Uważaj ze zbyt dużą ilością procesów programu na routerach z małą ilością pamięci RAM. Zalecane wartości to
		2-3 procesy. Poziom logowania: Najmniej szczegółowym poziomem logowania jest 'Tylko krytyczne', najbardziej
		szczegółowym - 'Wszystko'. Wybierając poziom logowania 'Informacje programu', w logu znajdą się też 'Uwagi programu',
		'Błędy programu' i 'Tylko krytyczne'. Poziom 'Nawiązane połączenia' zapisuje do pliku wszystkie nawiązane połączenia
		przez maszyny działające za proxy.</em>
        </div>

	</div>

</fieldset>

<div id="bottom_button_container">
	<input type='button' value='Zapisz zmiany' id="save_button" class="bottom_button" onclick='saveChanges()' />
	<input type='button' value='Anuluj' id="reset_button" class="bottom_button" onclick='resetData()'/>
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
