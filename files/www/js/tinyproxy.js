/*	
 * Copyright (c) 2010 Artur Wronowski <arteqw@gmail.com>
 */

function saveChanges()
{
	var enabled = getSelectedValue("tinyproxy_enabled");
	var loglevel = getSelectedValue("tinyproxy_loglevel");
	var tinyproxyPort = document.getElementById("tinyproxy_port").value;
	var allowips = document.getElementById("tinyproxy_allowips").value;
	
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
	
	preCommands.push("uci set tinyproxy.@tinyproxy[0].Listen=0.0.0.0");

	preCommands.push("uci set tinyproxy.@tinyproxy[0].Port='" + tinyproxyPort + "'");
	preCommands.push("uci set tinyproxy.@tinyproxy[0].LogLevel='" + loglevel + "'");
	preCommands.push("uci set tinyproxy.@tinyproxy[0].Allow='" + allowips + "'");

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

	var enabled = uciOriginal.get("tinyproxy", tpSections[0], "enable");
	setSelectedValue("tinyproxy_enabled", enabled);

//	var loglevel = uciOriginal.get("tinyproxy", tpSections[0], "LogLevel");
//	setSelectedValue("tinyproxy_loglevel", loglevel);

//	var allowips = uciOriginal.get("tinyproxy", tpSections[0], "Allow");
//      setSelectedValue("tinyproxy_allowips", allowips);
		
	document.getElementById("tinyproxy_port").value = uciOriginal.get("tinyproxy", tpSections[0], "Port");
	document.getElementById("tinyproxy_loglevel").value = uciOriginal.get("tinyproxy", tpSections[0], "LogLevel");
	document.getElementById("tinyproxy_allowips").value = uciOriginal.get("tinyproxy", tpSections[0], "Allow");	

	setVisibility();

}

