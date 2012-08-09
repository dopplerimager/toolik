

;\\ CLEANUP ROUTINES
pro ICOS_Tester_cleanup, misc, log

	dll = misc.dll_name

	comms_wrapper, misc.port_map.etalon.number, dll, type='moxa', /open, err=err
	print, 'Etalon port close: ' + string(err, f='(i0)')

	fport = misc.port_map.filter.number
	comms_wrapper, fport, dll, /close, err=err
	print, 'Filter port close: ' + string(err, f='(i0)')

end

;\\ MIRROR ROUTINES
pro ICOS_Tester_mirror,  drive_to_pos = drive_to_pos, $
				  home_motor = home_motor, $
				  read_pos = read_pos,  $
				  misc, log


end

;\\ CALIBRATION SWITCH ROUTINES
pro ICOS_Tester_switch, source, $
				  	    misc, $
				  	    log


end

;\\ FILTER SELECT ROUTINES
pro ICOS_Tester_filter, filter_number, $
					    log_path = log_path, $
				  	    misc, $
				  	    log

	fport = misc.port_map.filter.number
	dll = misc.dll_name
	inc = 801000L
	abs_pos = inc*(filter-1)
	comms_wrapper, fport, dll, /write, data = 'LA' + string(abs_pos, f='(i0)') + string(13B)
	comms_wrapper, fport, dll, /write, data = 'NP' + string(13B)
	comms_wrapper, fport, dll, /write, data = 'M' + string(13B)
	in = ''
	while strmid(in,0,1) ne 'p' do comms_wrapper, fport, dll, /read, data = in

end

;\\ ETALON LEG ROUTINES
pro ICOS_Tester_etalon, dll, $
				  leg1_voltage, $
				  leg2_voltage, $
				  leg3_voltage, $
				  misc, log


	sdi_cs100_etalon_driver, 'set_spacing', {port:misc.port_map.etalon.number, $
											dll:misc.dll_name, $
											comms:'moxa', $
											spacing:leg1_voltage}

end

;\\ INITIALISATION ROUTINES
pro ICOS_Tester_initialise, misc, log

	dll = misc.dll_name

	;\\ Etalon Init
		comms_wrapper, misc.port_map.etalon.number, dll, type='moxa', /open, err=err
		print, 'Etalon Port Open: ' + string(err, f='(i0)')
		sdi_cs100_etalon_driver, 'initialise', {port:misc.port_map.etalon.number, $
												dll:dll, $
												comms:'moxa'}, out, err
		print, 'CS100 Etalon Init: ' + out
		sdi_cs100_etalon_driver, 'set_x_parallelism', {port:misc.port_map.etalon.number, $
												dll:dll, $
												comms:'moxa', spacing:40}, out, err

		sdi_cs100_etalon_driver, 'set_y_parallelism', {port:misc.port_map.etalon.number, $
												dll:dll, $
												comms:'moxa', spacing:10}, out, err

	;\\ Filter Wheel Init
		fport = misc.port_map.filter.number
		comms_wrapper, fport, dll, /open, err=err
		print, 'Filter port open: ' + string(err, f='(i0)')

		comms_wrapper, fport, dll, /write, data = 'EN' + string(13B)
		comms_wrapper, fport, dll, /write, data = 'LPC900' + string(13B)
		comms_wrapper, fport, dll, /write, data = 'LCC500' + string(13B)
		comms_wrapper, fport, dll, /write, data = 'SP15000' + string(13B)
		comms_wrapper, fport, dll, /write, data = 'HOSP-10000' + string(13B)

		;\\ Home to the limit switch
		comms_wrapper, fport, dll, /write, data = 'NP' + string(13B)
		comms_wrapper, fport, dll, /write, data = 'GOIX' + string(13B)
		in = ''
		while strmid(in,0,1) ne 'p' do comms_wrapper, fport, dll, /read, data = in

end

