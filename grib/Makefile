WGET = /usr/bin/wget
WGET_OPTION = -q
GRIB_FTP_SITE = ftp://ftpprd.ncep.noaa.gov
GRIB_FTP_DIR = /pub/data/nccf/com/nam/prod

all: grib
grib: nam.t00z.awip3d12.tm00.grib2
nam.t00z.awip3d12.tm00.grib2:
	$(RM) nam.t00z.awip3d??.tm00.grib2
	$(WGET) $(WGET_OPTION) \
		$(GRIB_FTP_SITE)$(GRIB_FTP_DIR)/nam.$(utc_yyyy)$(utc_mon)$(utc_today)/nam.t00z.awip3d12.tm00.grib2
	$(WGET) $(WGET_OPTION) \
		$(GRIB_FTP_SITE)$(GRIB_FTP_DIR)/nam.$(utc_yyyy)$(utc_mon)$(utc_today)/nam.t00z.awip3d15.tm00.grib2
	$(WGET) $(WGET_OPTION) \
		$(GRIB_FTP_SITE)$(GRIB_FTP_DIR)/nam.$(utc_yyyy)$(utc_mon)$(utc_today)/nam.t00z.awip3d18.tm00.grib2
	$(WGET) $(WGET_OPTION) \
		$(GRIB_FTP_SITE)$(GRIB_FTP_DIR)/nam.$(utc_yyyy)$(utc_mon)$(utc_today)/nam.t00z.awip3d21.tm00.grib2
	$(WGET) $(WGET_OPTION) \
		$(GRIB_FTP_SITE)$(GRIB_FTP_DIR)/nam.$(utc_yyyy)$(utc_mon)$(utc_today)/nam.t00z.awip3d24.tm00.grib2

clean:
	$(RM) nam.t00z.awip3d??.tm00.grib2
