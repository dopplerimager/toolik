

;\\ CLEANUP ROUTINES
pro ICOS_Tester_cleanup, misc, log

	dll = misc.dll_name

	comms_wrapper, misc.port_map.etalon.number, dll, type='moxa', /close, err=err
	print, 'Etalon port close: ' + string(err, f='(i0)')

	comms_wrapper, misc.port_map.filter.number, dll, type='moxa', /close, err=err
	print, 'Filter port close: ' + string(err, f='(i0)')

	comms_wrapper, misc.port_map.mirror.number, dll, type='moxa', /close, err=err
	print, 'Mirror port close: ' + string(err, f='(i0)')

end


;\\ MIRROR ROUTINES
pro ICOS_Tester_mirror,  drive_to_pos = drive_to_pos, $
				 		 home_motor = home_motor, $
				 		 read_pos = read_pos,  $
				 		 misc, console

	;\\ Stop the camera while we move the mirror:
	   	res = call_external(misc.dll_name, 'uAbortAcquisition')

	;\\ Misc stuff
		port = misc.port_map.mirror.number
		dll_name = misc.dll_name
		tx = string(13B)

	;\\ Set current limits
		comms_wrapper, port, dll_name, type='moxa', /write, data = 'LCC800'  + tx ;\\ set these here to be safe...
		comms_wrapper, port, dll_name, type='moxa', /write, data = 'LPC1200' + tx

	;\\ Drive to sky or cal position:
		if keyword_set(drive_to_pos) then begin
			;\\ Notify that we are changing the mirror position
				base = widget_base(col=1, group=misc.console_id, /floating)
				info = widget_label(base, value='Driving Mirror to ' + string(drive_to_pos, f='(i0)'), font='Ariel*20*Bold')
				widget_control, /realize, base

				res = drive_motor(port, dll_name, drive_to = drive_to_pos, speed = 1000)
				read_pos = drive_motor(port, dll_name, /readpos)

			;\\ Close notification window
				if widget_info(base, /valid) eq 1 then widget_control, base, /destroy
		endif


	;\\ Home to the sky or calibration positions
		if keyword_set(home_motor) then begin

			;\\ Notify that we are homing the mirror
				base = widget_base(col=1, group=misc.console_id, /floating)
				info = widget_label(base, value='Homing Mirror to ' + home_motor, font='Ariel*20*Bold')
				widget_control, /realize, base

		    if strlowcase(home_motor) eq 'sky' then direction = 'forwards'
		    if strlowcase(home_motor) eq 'cal' then direction = 'backwards'

			ntries = 0
			GO_HOME_MOTOR_START:

				pos1 = drive_motor(port, dll_name, /readpos)
				res  = drive_motor(port, dll_name, direction = direction, speed = 1000., home_max_spin_time = 3.)
				pos2 = drive_motor(port, dll_name, /readpos)
				ntries = ntries + 1

			if abs(pos2 - pos1)/1000. gt .3 or ntries lt 2 then goto, GO_HOME_MOTOR_START
			read_pos = drive_motor(port, dll_name, /readpos)

			if strlowcase(home_motor) eq 'cal' then	begin
				;comms_wrapper, port, dll_name, type='moxa', /write, data = 'HOSP500'  + tx
				print, 'LAS A: ', read_pos
				res = drive_motor(port, dll_name, control = 'setpos0')
				res = drive_motor(port, dll_name, drive_to = 8000, timeout=5, speed = 1000)
				;res = drive_motor(port, dll_name, /gohix)
			endif else begin
				print, 'SKY A: ', read_pos
				res = drive_motor(port, dll_name, drive_to = read_pos - 8000, timeout=5, speed = 1000)
			endelse

			;\\ Close notification window
				if widget_info(base, /valid) eq 1 then widget_control, base, /destroy
		endif

	read_pos = drive_motor(port, dll_name, /readpos)
	print, 'B: ', read_pos

	;\\ Restart the camera
		res = call_external(misc.dll_name, 'uStartAcquisition')


end

;\\ CALIBRATION SWITCH ROUTINES
pro ICOS_Tester_switch,source, $
				    misc, $
				    console, $
				    home=home

	case source of
		0: motor_pos = -150
		1: motor_pos = -850
		2: motor_pos = -1650
		3: motor_pos = -2400
		else:
	endcase

	port = misc.port_map.cal_source.number
	dll_name = misc.dll_name
	tx = string(13B)

	;\\ Notification window
	if keyword_set(home) then info_string = 'Homing Calibration Source' $
		else info_string = 'Driving to Calibration Source ' + string(source, f='(i01)') + $
			 ' at Pos: ' + string(motor_pos, f='(i0)')

		base = widget_base(col=1, group=misc.console_id, /floating)
		info = widget_label(base, value=info_string, font='Ariel*20*Bold', xs=400)
		widget_control, /realize, base

	;\\ Set the current limits
		comms_wrapper, port, dll_name, type='moxa', /write, data = 'LCC150'  + tx
		comms_wrapper, port, dll_name, type='moxa', /write, data = 'LPC200'  + tx

	if keyword_set(home) then begin
		;\\ Enable the motor
		comms_wrapper, port, dll_name, type='moxa', /write, data = 'EN'  + tx
		;\\ Call current position 0
		comms_wrapper, port, dll_name, type='moxa', /write, data = 'HO'  + tx
		;\\ Set a low speed, 5 RPM
		comms_wrapper, port, dll_name, type='moxa', /write, data = 'SP5'  + tx
		;\\ Drive two full revolutions, so we have to hit the stop at some point
		comms_wrapper, port, dll_name, type='moxa', /write, data = 'LA6000'  + tx

		;\\ Note the current time
		home_start_time = systime(/sec)
		;\\ Initiate the motion
		comms_wrapper, port, dll_name, type='moxa', /write, data = 'M'  + tx

		;\\ Wait 10 seconds
		while (systime(/sec) - home_start_time) lt 10 do begin
			wait, 0.5
			widget_control, set_value ='Homing Calibration Source ' + $
					string(10 - (systime(/sec) - home_start_time), f='(f0.1)'), info
		endwhile

		;\\ Call the home position 0
		comms_wrapper, port, dll_name, type='moxa', /write, data = 'HO'  + tx
		comms_wrapper, port, dll_name, type='moxa', /write, data = 'SP50'  + tx
		;\\ Drive a little bit away from it
		comms_wrapper, port, dll_name, type='moxa', /write, data = 'LA-10'  + tx
		comms_wrapper, port, dll_name, type='moxa', /write, data = 'M'  + tx
		wait, 2.

		print, 'Cal Source Homed'
		comms_wrapper, port, dll_name, type = 'moxa', /write, data = 'DI'+tx

	endif else begin

		comms_wrapper, port, dll_name, type = 'moxa', /write, data = 'EN'+tx
		comms_wrapper, port, dll_name, type='moxa', /write, data = 'LA' + string(motor_pos, f='(i0)') + tx
		comms_wrapper, port, dll_name, type='moxa', /write, data = 'M' + tx
		wait, 6.
		comms_wrapper, port, dll_name, type = 'moxa', /write, data = 'DI'+tx

	endelse

	;\\ Close notification window
		if widget_info(base, /valid) eq 1 then widget_control, base, /destroy
end



;\\ FILTER SELECT ROUTINES
pro ICOS_Tester_filter, filter_number, $
					    log_path = log_path, $
				  	    misc, $
				  	    log

	fport = misc.port_map.filter.number
	dll = misc.dll_name
	inc = 801000L
	abs_pos = inc*(filter_number-1)
	comms_wrapper, fport, dll, /write, type='moxa', data = 'LA' + string(abs_pos, f='(i0)') + string(13B)
	comms_wrapper, fport, dll, /write, type='moxa', data = 'NP' + string(13B)
	comms_wrapper, fport, dll, /write, type='moxa', data = 'M' + string(13B)
	in = ''
	while strmid(in,0,1) ne 'p' do comms_wrapper, fport, dll, type='moxa', /read, data = in

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


pro ICOS_Tester_imageprocess, img

end


;\\ INITIALISATION ROUTINES
pro ICOS_Tester_initialise, misc, console

	dll = misc.dll_name

	;\\ Set up the com ports
	comms_wrapper, misc.port_map.cal_source.number, misc.dll_name, type = 'moxa', /open, errcode=errcode, moxa_setbaud=12
	console->log, 'Open Calibration Source Port: ' + string(errcode, f='(i0)'), 'InstrumentSpecific', /display
	comms_wrapper, misc.port_map.mirror.number, misc.dll_name, type = 'moxa', /open, errcode=errcode, moxa_setbaud=12
	console->log, 'Open Mirror Port: ' + string(errcode, f='(i0)'), 'InstrumentSpecific', /display
	comms_wrapper, misc.port_map.filter.number, misc.dll_name, type = 'moxa', /open, errcode=errcode, moxa_setbaud=12
	console->log, 'Open Filter Port: ' + string(errcode, f='(i0)'), 'InstrumentSpecific', /display
	comms_wrapper, misc.port_map.etalon.number, misc.dll_name, type = 'moxa', /open, errcode=errcode, moxa_setbaud=14
	console->log, 'Open Etalon Port: ' + string(errcode, f='(i0)'), 'InstrumentSpecific', /display


	;\\ Initialise Faulhaber motors
	tx = string(13B)
	comms_wrapper, misc.port_map.cal_source.number, misc.dll_name, type='moxa', /write, data = 'DI'+tx  ;\\ disable cal source motor
	comms_wrapper, misc.port_map.mirror.number, misc.dll_name, type='moxa', /write, data = 'EN'+tx 	  ;\\ enable mirror motor
	comms_wrapper, misc.port_map.mirror.number, misc.dll_name, type='moxa', /write, data = 'ANSW1'+tx


	;\\ Etalon Init
		sdi_cs100_etalon_driver, 'initialise', {port:misc.port_map.etalon.number, $
												dll:dll, $
												comms:'moxa'}, out, err
		console->log, 'CS100 Etalon Init: ' + out, 'InstrumentSpecific', /display
		sdi_cs100_etalon_driver, 'set_x_parallelism', {port:misc.port_map.etalon.number, $
												dll:dll, $
												comms:'moxa', spacing:40}, out, err
		sdi_cs100_etalon_driver, 'set_y_parallelism', {port:misc.port_map.etalon.number, $
												dll:dll, $
												comms:'moxa', spacing:10}, out, err

	return

	;\\ Filter Wheel Init
		fport = misc.port_map.filter.number
		comms_wrapper, fport, dll, type='moxa', /write, data = 'EN' + tx
		comms_wrapper, fport, dll, type='moxa', /write, data = 'LPC1000' + tx
		comms_wrapper, fport, dll, type='moxa', /write, data = 'LCC1500' + tx
		comms_wrapper, fport, dll, type='moxa', /write, data = 'SP15000' + tx
		comms_wrapper, fport, dll, type='moxa', /write, data = 'HOSP-10000' + tx

	;\\ Home to the limit switch
		res = drive_motor(fport, dll, /goix, timeout=30)
end

