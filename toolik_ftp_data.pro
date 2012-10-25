
pro Toolik_ftp_data, force=force

common data_xfer_semaphore, xfer_tstamp

	command_string = 'idlde -e "data_transfer, ' + "data_dir = 'c:\users\sdi3000\data\awaiting_transfer\', " + $
				   		"sent_dir = 'c:\users\sdi3000\data\sent\', " + $
				   		"ftp_command = 'psftp 137.229.27.190 -l instrument -pw aer0n0my', " + $
	 			   		"site = 'TLK'" + '"'

	spawn, command_string, /nowait


;	   ftp_script = 'c:\SDI_ftp_script.ftp'
;       openw, spunt, ftp_script, /get_lun
;       printf, spunt, 'cd instrument_incomming'
;       printf, spunt, 'lcd c:\users\sdi3000\data\awaiting_transfer'
;       printf, spunt, 'mput *.nc'
;       printf, spunt, 'mput *.pf'
;       printf, spunt, 'quit'
;       close, spunt
;       free_lun, spunt
;
;       bat_script = 'c:\SDI_data_xfer.bat'
;       openw, spunt, bat_script, /get_lun
;       printf, spunt, 'c:'
;       printf, spunt, 'cd \users\sdi3000\data\awaiting_transfer'
;       printf, spunt, 'psftp 137.229.27.190 -l instrument -pw aer0n0my -b ' + ftp_script
;       printf, spunt, 'move *.nc ..\sent'
;       printf, spunt, 'move *.pf ..\sent'
;       close, spunt
;       free_lun, spunt

;       ftp_script = 'c:\users\sdi3000\SDI_ftp_script.ftp'
;       openw, spunt, ftp_script, /get_lun
;       printf, spunt, 'sdi3000'
;       printf, spunt, 'fabryPER0T'
;       printf, spunt, 'cd data/Toolik_Lake'
;       printf, spunt, 'lcd c:\users\sdi3000\data\awaiting_transfer'
;       printf, spunt, 'bin'
;       printf, spunt, 'hash'
;       printf, spunt, 'prompt'
;       printf, spunt, 'mput *.nc'
;       printf, spunt, 'mput *.pf'
;       printf, spunt, 'quit'
;       close, spunt
;       free_lun, spunt
;
;       bat_script = 'c:\users\sdi3000\SDI_data_xfer.bat'
;       openw, spunt, bat_script, /get_lun
;       printf, spunt, 'cd c:\users\sdi3000\data\awaiting_transfer'
;       printf, spunt, 'ftp -s:' + ftp_script + ' fulcrum.gi.alaska.edu'
;       printf, spunt, 'move *.nc ..\sent'
;       printf, spunt, 'move *.pf ..\sent'
;       close, spunt
;       free_lun, spunt

;       spawn, bat_script, /nowait

end