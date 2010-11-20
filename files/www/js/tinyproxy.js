/*	
 * This program is copyright © 2010 Artur Wronowski <arteqw@gmail.com> and is distributed under the terms of the GNU GPL 
 * version 2.0 with a special clarification/exception that permits adapting the program to 
 * configure proprietary "back end" software provided that all modifications to the web interface
 * itself remain covered by the GPL. 
 * See http://gargoyle-router.com/faq.html#qfoss for more information
 */

function saveChanges()
{
	var enabled = getSelectedValue("tinyproxy_enabled");
	var loglevel = getSelectedValue("tinyproxy_loglevel");
	var tinyproxyPort = document.getElementById("tinyproxy_port").value;
	
	var errors = [];
	if (tinyproxyPort == "")
	{
		errors.push("Enter tinyproxy port");
	}
	if (errors.length > 0)
	{
		alert( errors.join("\n") + "\n\nCould not save settings" );
		return;
	}
	
	setControlsEnabled(false, true);

	var uci = uciOriginal.clone();
	
	var preCommands = [];
	
	preCommands.push("uci set tinyproxy.@tinyproxy[0].Port='" + tinyproxyPort + "'");
	preCommands.push("uci set tinyproxy.@tinyproxy[0].LogLevel='" + loglevel + "'");

	var postCommands = [];

	if(enabled == "1")
	{
		preCommands.push("uci set tinyproxy.@tinyproxy[0].enable=1");
		postCommands.push("/etc/init.d/tinyproxy enable");
	}
	if(enabled == "0")
	{
		preCommands.push("uci set tinyproxy.@tinyproxy[0].enable=0");
		postCommands.push("/etc/init.d/tinyproxy disable");
	}

	preCommands.push("uci commit");
	postCommands.push("/etc/init.d/tinyproxy restart");

	var commands = preCommands.join("\n") + "\n" +  uci.getScriptCommands(uciOriginal) + "\n" + postCommands.join("\n") + "\n";
//	var commands = preCommands.join("\n") + "\n" + postCommands.join("\n") + "\n";
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


function setVisibility()
{
	setInvisibleIfIdMatches("tinyproxy_enabled", "0", "tinyproxy_container", "block", document);
}

function resetData()
{
	var tpSections = uciOriginal.getAllSectionsOfType("tinyproxy", "tinyproxy");

	var enabled = uciOriginal.get("tinyproxy", tpSections[0], "Enable");
	setSelectedValue("tinyproxy_enabled", enabled);

	var loglevel = uciOriginal.get("tinyproxy", tpSections[0], "LogLevel");
	setSelectedValue("tinyproxy_loglevel", loglevel);
		
	document.getElementById("tinyproxy_port").value = uciOriginal.get("tinyproxy", tpSections[0], "Port");
	document.getElementById("tinyproxy_loglevel").value = uciOriginal.get("tinyproxy", tpSections[0], "LogLevel");
	
	setVisibility();

}

