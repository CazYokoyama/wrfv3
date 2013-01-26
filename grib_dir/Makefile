WGET = /usr/bin/wget
WGET_OPTION = -q
GRIB_FTP_SITE = ftp://ftpprd.ncep.noaa.gov
GRIB_FTP_DIR = /pub/data/nccf/com/nam/prod

utc_today=$(shell date --utc +%Y%m%d)

all: grib

grib: file_available nam.t00z.awip3d12.tm00.grib2 
nam.t00z.awip3d12.tm00.grib2: mark_file
	@$(RM) nam.t00z.awip3d??.tm00.grib2*
	$(WGET) $(WGET_OPTION) \
		$(GRIB_FTP_SITE)$(GRIB_FTP_DIR)/nam.$(utc_today)/nam.t00z.awip3d12.tm00.grib2
	$(WGET) $(WGET_OPTION) \
		$(GRIB_FTP_SITE)$(GRIB_FTP_DIR)/nam.$(utc_today)/nam.t00z.awip3d15.tm00.grib2
	$(WGET) $(WGET_OPTION) \
		$(GRIB_FTP_SITE)$(GRIB_FTP_DIR)/nam.$(utc_today)/nam.t00z.awip3d18.tm00.grib2
	$(WGET) $(WGET_OPTION) \
		$(GRIB_FTP_SITE)$(GRIB_FTP_DIR)/nam.$(utc_today)/nam.t00z.awip3d21.tm00.grib2
	$(WGET) $(WGET_OPTION) \
		$(GRIB_FTP_SITE)$(GRIB_FTP_DIR)/nam.$(utc_today)/nam.t00z.awip3d24.tm00.grib2
	$(WGET) $(WGET_OPTION) \
		$(GRIB_FTP_SITE)$(GRIB_FTP_DIR)/nam.$(utc_today)/nam.t00z.awip3d27.tm00.grib2

file_available:
	touch --date="`date --utc +%F` 00:00Z" mark_file

clean: file_available
	$(RM) nam.t00z.awip3d??.tm00.grib2* *~
