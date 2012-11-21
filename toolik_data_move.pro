
;\\ Move Toolik data into a holding directory, for later scheduled transfer
pro Toolik_Data_Move

	common Toolik_Data_Move, last_run_time

	if (size(last_run_time, /type) ne 0) then begin
		time_diff = (systime(/sec) - last_run_time) / 3600.
		if (time_diff lt 12) then return
	endif

	move_to = 'c:\users\sdi3000\data\awaiting_transfer\'
	files = file_search('c:\users\sdi3000\data\*.nc', count = nfiles)

	if nfiles eq 0 then begin
		last_run_time = systime(/sec)
		return
	endif

	fnames = file_basename(files)
	fdirs = file_dirname(files)

	file_move, files, move_to + fnames, /verbose

	last_run_time = systime(/sec)

end