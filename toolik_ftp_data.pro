
pro Toolik_ftp_data, force=force

common data_xfer_semaphore, xfer_tstamp

       ftp_script = 'c:\users\sdi3000\SDI_ftp_script.ftp'
       openw, spunt, ftp_script, /get_lun
       printf, spunt, 'sdi3000'
       printf, spunt, 'fabryPER0T'
       printf, spunt, 'cd data/Toolik_Lake'
       printf, spunt, 'lcd c:\users\sdi3000\data\awaiting_transfer'
       printf, spunt, 'bin'
       printf, spunt, 'hash'
       printf, spunt, 'prompt'
       printf, spunt, 'mput *.nc'
       printf, spunt, 'mput *.pf'
       printf, spunt, 'quit'
       close, spunt
       free_lun, spunt

       bat_script = 'c:\users\sdi3000\SDI_data_xfer.bat'
       openw, spunt, bat_script, /get_lun
       printf, spunt, 'cd c:\users\sdi3000\data\awaiting_transfer'
       printf, spunt, 'ftp -s:' + ftp_script + ' fulcrum.gi.alaska.edu'
       printf, spunt, 'move *.nc ..\sent'
       printf, spunt, 'move *.pf ..\sent'
       close, spunt
       free_lun, spunt

       spawn, bat_script, /nowait

end