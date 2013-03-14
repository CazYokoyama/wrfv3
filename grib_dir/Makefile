WGET = /usr/bin/wget
WGET_OPTION = -q
GRIB_FTP_SITE = ftp://ftpprd.ncep.noaa.gov
GRIB_FTP_DIR = /pub/data/nccf/com/nam/prod

#utc_today=$(shell date --utc +%Y%m%d)
utc_today=$(shell date --utc --date=yesterday +%Y%m%d)

all: grib

grib: file_available nam.t12z.awip3d00.tm00.grib2 
nam.t12z.awip3d00.tm00.grib2: mark_file
	@$(RM) nam.t12z.awip3d??.tm00.grib2*
	$(WGET) $(WGET_OPTION) \
		$(GRIB_FTP_SITE)$(GRIB_FTP_DIR)/nam.$(utc_today)/nam.t12z.awip3d00.tm00.grib2
	$(WGET) $(WGET_OPTION) \
		$(GRIB_FTP_SITE)$(GRIB_FTP_DIR)/nam.$(utc_today)/nam.t12z.awip3d03.tm00.grib2
	$(WGET) $(WGET_OPTION) \
		$(GRIB_FTP_SITE)$(GRIB_FTP_DIR)/nam.$(utc_today)/nam.t12z.awip3d06.tm00.grib2
	$(WGET) $(WGET_OPTION) \
		$(GRIB_FTP_SITE)$(GRIB_FTP_DIR)/nam.$(utc_today)/nam.t12z.awip3d09.tm00.grib2
	$(WGET) $(WGET_OPTION) \
		$(GRIB_FTP_SITE)$(GRIB_FTP_DIR)/nam.$(utc_today)/nam.t12z.awip3d12.tm00.grib2
	$(WGET) $(WGET_OPTION) \
		$(GRIB_FTP_SITE)$(GRIB_FTP_DIR)/nam.$(utc_today)/nam.t12z.awip3d15.tm00.grib2

file_available:
	touch --date="`date --utc +%F` 00:00Z" mark_file

clean: file_available
	$(RM) nam.t12z.awip3d??.tm00.grib2* *~
