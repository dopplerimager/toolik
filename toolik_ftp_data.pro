
pro Toolik_ftp_data, force=force

common data_xfer_semaphore, xfer_tstamp

	if n_elements(xfer_tstamp) eq 0 then xfer_tstamp = 0d
	jsnow   = dt_tm_tojs(systime())
	if jsnow - xfer_tstamp lt 12d*3600d and not(keyword_set(force)) then return
	xfer_tstamp = jsnow

	command_string = 'idlde -e "data_transfer, ' + "data_dir = 'c:\users\sdi3000\data\awaiting_transfer\', " + $
				   		"sent_dir = 'c:\users\sdi3000\data\sent\', " + $
				   		"ftp_command = 'toolik:aer0n0my@137.229.27.190', " + $
	 			   		"site = 'TLK'" + '"'

	spawn, command_string, /nowait
end