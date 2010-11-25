#!/usr/bin/haserl
<?
	# Copyright (c)  2010 Artur Wronowski <arteqw@gmail.com> 
	eval $( gargoyle_session_validator -c "$COOKIE_hash" -e "$COOKIE_exp" -a "$HTTP_USER_AGENT" -i "$REMOTE_ADDR" -r "login.sh" -t $(uci get gargoyle.global.session_timeout) -b "$COOKIE_browser_time"  )
	gargoyle_header_footer -m -c "internal.css" -j "tinyproxy.js table.js"
?>
<pre>
<span style="overflow:scrol;white-space:pre-wrap">
<? cat /var/log/tinyproxy.log ?>
</span>
</pre>

</body>
</html>
