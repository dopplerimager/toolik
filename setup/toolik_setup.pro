pro toolik_setup, data

	;\\ ETALON
	data.etalon.NUMBER_OF_CHANNELS = 128
	data.etalon.LEG1_OFFSET = 1.000000
	data.etalon.LEG2_OFFSET = 1.000000
	data.etalon.LEG3_OFFSET = 1.000000
	data.etalon.LEG1_BASE_VOLTAGE = 0
	data.etalon.LEG2_BASE_VOLTAGE = 0
	data.etalon.LEG3_BASE_VOLTAGE = 0
	data.etalon.NM_PER_STEP = 0.007722
	data.etalon.NM_PER_STEP_REFRESH_HOURS = 1000000.000000
	data.etalon.GAP_REFRACTIVE_INDEX = 0.000000
	data.etalon.PHASEMAP_REFRESH_HOURS = 1000000.000000
	data.etalon.GAP = 0.000000
	data.etalon.MAX_VOLTAGE = 4095


	;\\ CAMERA
	data.camera.EXPOSURE_TIME = 0.100000
	data.camera.READ_MODE = 4
	data.camera.ACQUISITION_MODE = 5
	data.camera.TRIGGER_MODE = 0
	data.camera.SHUTTER_MODE = 0
	data.camera.SHUTTER_CLOSING_TIME = 0
	data.camera.SHUTTER_OPENING_TIME = 0
	data.camera.VERT_SHIFT_SPEED = 4
	data.camera.COOLER_ON = 1
	data.camera.COOLER_TEMP = -100
	data.camera.FAN_MODE = 0
	data.camera.CAM_TEMP = -95.472000
	data.camera.XBIN = 2
	data.camera.YBIN = 2
	data.camera.GAIN = 1
	data.camera.XCEN = 256
	data.camera.YCEN = 256
	data.camera.PREAMP_GAIN = 0
	data.camera.BASELINE_CLAMP = 1
	data.camera.EM_GAIN_MODE = 3
	data.camera.VS_AMPLITUDE = 0
	data.camera.AD_CHANNEL = 0
	data.camera.OUTPUT_AMPLIFIER = 0
	data.camera.HS_SPEED = 2
	data.camera.XPIX = 1024
	data.camera.YPIX = 1024


	;\\ HEADER
	data.header.SITE = 'Toolik'
	data.header.SITE_CODE = 'TLK'
	data.header.INSTRUMENT_NAME = 'Toolik'
	data.header.LONGITUDE = -149.600006
	data.header.LATITUDE = 68.629997
	data.header.YEAR = '2012'
	data.header.DOY = ''
	data.header.OPERATOR = 'Cal'
	data.header.COMMENT = 'Testing the ICOS Etalon'
	data.header.SOFTWARE = ''


	;\\ LOGGING
	data.logging.LOG_DIRECTORY = 'C:\Users\sdi3000\Log\'
	data.logging.TIME_NAME_FORMAT = 'doy$'
	data.logging.ENABLE_LOGGING = 1
	data.logging.LOG_OVERWRITE = 0
	data.logging.LOG_APPEND = 1
	data.logging.FTP_SNAPSHOT = '137.229.27.190 -l toolik -pw aer0n0my'


	;\\ MISC
	data.misc.DEFAULT_SETTINGS_PATH = 'C:\Users\sdi3000\Settings\'
	data.misc.SCREEN_CAPTURE_PATH = 'C:\Users\sdi3000\screencapture\'
	data.misc.PHASE_MAP_PATH = 'C:\Users\sdi3000\Phasemaps\'
	data.misc.ZONE_SET_PATH = 'C:\Users\sdi3000\toolik\ZoneMaps\'
	data.misc.SPECTRA_PATH = 'C:\Users\sdi3000\data\'
	data.misc.DLL_NAME = 'C:\Users\sdi3000\sdi\bin\sdi_external.dll'
	data.misc.TIMER_TICK_INTERVAL = 0.001000
	data.misc.SHUTDOWN_ON_EXIT = 0
	data.misc.MOTOR_SKY_POS = 102802
	data.misc.MOTOR_CAL_POS = 5999
	data.misc.PORT_MAP.MIRROR.NUMBER = 9
	data.misc.PORT_MAP.MIRROR.TYPE = 'unknown'
	data.misc.PORT_MAP.MIRROR.SETTINGS = 'none'

	data.misc.PORT_MAP.CAL_SOURCE.NUMBER = 8
	data.misc.PORT_MAP.CAL_SOURCE.TYPE = 'unknown'
	data.misc.PORT_MAP.CAL_SOURCE.SETTINGS = 'none'

	data.misc.PORT_MAP.ETALON.NUMBER = 3
	data.misc.PORT_MAP.ETALON.TYPE = 'unknown'
	data.misc.PORT_MAP.ETALON.SETTINGS = 'none'

	data.misc.PORT_MAP.FILTER.NUMBER = 10
	data.misc.PORT_MAP.FILTER.TYPE = 'unknown'
	data.misc.PORT_MAP.FILTER.SETTINGS = 'none'


	data.misc.SOURCE_MAP.S0 = 0
	data.misc.SOURCE_MAP.S1 = 0
	data.misc.SOURCE_MAP.S2 = 0
	data.misc.SOURCE_MAP.S3 = 0

	data.misc.SNAPSHOT_REFRESH_HOURS = 0.000000

end
