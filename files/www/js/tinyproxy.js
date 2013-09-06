/*
 * Copyright (c) 2010-2013 Artur Wronowski <arteqw@gmail.com>
 */

function saveChanges()
{
	var enabled = getSelectedValue("tinyproxy_enabled");
	var loglevel = getSelectedValue("tinyproxy_loglevel");
	var startservers = getSelectedValue("tinyproxy_startservers");
	var tinyproxyPort = document.getElementById("tinyproxy_port").value;
	var allowips = document.getElementById("tinyproxy_allowips").value;
//	var allowips_custom = document.getElementById("tinyproxy_allowipsedit").value;
	var allowips_option = getSelectedValue("tinyproxy_allowips").value;
	var transproxy = getSelectedValue("tinyproxy_transparent");
	var filterurl = getSelectedValue("tinyproxy_filterurl");

	var filter_file = new Array();
	var filter_file = document.getElementById("tinyproxy_filterurledit").value.split('\n');

	var errors = [];
	if (tinyproxyPort == "" || tinyproxyPort == "0")
	{
		errors.push("Wpisz port tinyproxy");
	}
	if (errors.length > 0)
	{
		alert( errors.join("\n") + "\n\nNie można zapisać ustawień" );
		return;
	}

	setControlsEnabled(false, true);

	var uci = uciOriginal.clone();

	var preCommands = [];

	preCommands.push("uci set tinyproxy.@tinyproxy[0].Listen=0.0.0.0");
	preCommands.push("uci set tinyproxy.@tinyproxy[0].Port='" + tinyproxyPort + "'");
	preCommands.push("uci set tinyproxy.@tinyproxy[0].LogLevel='" + loglevel + "'");
	preCommands.push("uci set tinyproxy.@tinyproxy[0].Allow='" + allowips + "'");
	preCommands.push("uci set tinyproxy.@tinyproxy[0].StartServers='" + startservers + "'");
	preCommands.push("uci set tinyproxy.@tinyproxy[0].FilterURL='" + filterurl + "'");
	preCommands.push("uci set tinyproxy.@tinyproxy[0].Filter=/etc/tinyproxy/filter");

	// add content to file
	createFilterCommands = [ "mkdir /etc/tinyproxy", "touch /etc/tinyproxy/filter" ];
	createFilterCommands.push("echo \"" + filter_file.join('\n') + "\" > /etc/tinyproxy/filter");

	var postCommands = [];

	routerIP = uciOriginal.get("network", "lan", "ipaddr");
	var TransparentRule = [ "iptables -t nat -A PREROUTING -i br-lan -p tcp ! -d " + routerIP  + " --dport 80 -j REDIRECT --to-port " + tinyproxyPort ];
	var SingleIPRule = [ "iptables -t nat -I PREROUTING czes-s " + allowips  + " -p tcp --dport 80 -j REDIRECT --to-port " + tinyproxyPort ];
    var createFirewallRule = [];

	if(transproxy == "1")
	{
		createFirewallRule.push("echo \"" + TransparentRule + "\" > /etc/tinyproxy.rule");
		preCommands.push("uci set tinyproxy.@tinyproxy[0].TransparentProxy=1");
	}
	else
	{
		createFirewallRule.push("sed -i 's/"+ TransparentRule +"//g' /etc/tinyproxy.rule");
		preCommands.push("uci set tinyproxy.@tinyproxy[0].TransparentProxy=0");
	}

    if(enabled == "1")
    {
		preCommands.push("uci set tinyproxy.@tinyproxy[0].enabled=1");
		postCommands.push("/etc/init.d/tinyproxy enable");
    }
    if(enabled == "0")
    {
		createFirewallRule.push("sed -i 's/"+ TransparentRule +"//g' /etc/tinyproxy.rule");
		preCommands.push("uci set tinyproxy.@tinyproxy[0].enabled=0");
		postCommands.push("/etc/init.d/tinyproxy disable");
    }


	//create Log File
	var createLogFile = [ "touch /var/log/tinyproxy.log", "chown nobody.nogroup /var/log/tinyproxy.log" ];

	preCommands.push("uci commit");

	postCommands.push("/etc/init.d/tinyproxy restart");
	postCommands.push("/etc/init.d/firewall restart");

	var commands = createFilterCommands.join("\n") + "\n" + createFirewallRule.join("\n") + "\n" + createLogFile.join("\n") + "\n" + preCommands.join("\n") + "\n" +  uci.getScriptCommands(uciOriginal) + "\n" + postCommands.join("\n") + "\n";
	var param = getParameterDefinition("commands", commands) + "&" + getParameterDefinition("hash", document.cookie.replace(/^.*hash=/,"").replace(/[\t ;]+.*$/, ""));

	var stateChangeFunction = function(req)
	{
		if(req.readyState == 4)
		{
			uciOriginal = uci.clone();
			setControlsEnabled(true);
		}
	}

	runAjax("POST", "utility/run_commands.sh", param, stateChangeFunction);
}


function setVisibilityTinyproxy()
{
	setInvisibleIfIdMatches("tinyproxy_enabled", "0", "tinyproxy_container", "block", document);
}

function setVisibilityFilterURL()
{
        setInvisibleIfIdMatches("tinyproxy_filterurl", ["Off"], "tinyproxy_filterurledit_container", "block", document);
}

function setVisibilityAllowIP()
{
        setInvisibleIfIdMatches("tinyproxy_allowips", ["all"], "tinyproxy_allowipedit_container", "block", document);
}

function showLog()
{

if( typeof(viewLogWindow) != "undefined" )
	{
		//opera keeps object around after
		//window is closed, so we need to deal
		//with error condition
		try
		{
			viewLogWindow.close();
		}
		catch(e){}
	}


	try
	{
		xCoor = window.screenX + 225;
		yCoor = window.screenY+ 225;
	}
	catch(e)
	{
		xCoor = window.left + 225;
		yCoor = window.top + 125;
	}

	viewLogWindow = window.open("tinyproxy_view.sh", "Log", "width=800,height=600,left=" + xCoor + ",top=" + yCoor );

}

function resetData()
{

	//FilterURL disable by default
	setSelectedValue("tinyproxy_filterurl", "Off", document);
	setSelectedValue("tinyproxy_transparent", "0", document);
	setSelectedValue("tinyproxy_allowips", "all", document);

	var tpSections = uciOriginal.getAllSectionsOfType("tinyproxy", "tinyproxy");

	var enabled = uciOriginal.get("tinyproxy", tpSections[0], "enabled");
	setSelectedValue("tinyproxy_enabled", enabled);

	var filterurl = uciOriginal.get("tinyproxy", tpSections[0], "FilterURL");
	setSelectedValue("tinyproxy_filterurl", filterurl);

	var startservers = uciOriginal.get("tinyproxy", tpSections[0], "StartServers");
	setSelectedValue("tinyproxy_startservers", startservers);

	var transproxy = uciOriginal.get("tinyproxy", tpSections[0], "TransparentProxy");
	setSelectedValue("tinyproxy_transparent", transproxy);

	document.getElementById("tinyproxy_port").value = uciOriginal.get("tinyproxy", tpSections[0], "Port");
	document.getElementById("tinyproxy_loglevel").value = uciOriginal.get("tinyproxy", tpSections[0], "LogLevel");
	document.getElementById("tinyproxy_allowips").value = uciOriginal.get("tinyproxy", tpSections[0], "Allow");

	document.getElementById("tinyproxy_filterurledit").value = filterurl_file.join('\n');

	setVisibilityTinyproxy();
	setVisibilityFilterURL();
	setVisibilityAllowIP();
}