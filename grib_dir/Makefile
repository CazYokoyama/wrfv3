WGET = /usr/bin/wget
WGET_OPTION = --append-output=wget-${base_hh_utc}.log
GRIB_FTP_SITE = ftp://ftpprd.ncep.noaa.gov
GRIB_FTP_DIR = /pub/data/nccf/com/nam/prod

ifeq (${yesterday},true)
	utc_today=$(shell date --utc --date=yesterday +%Y%m%d)
else
	utc_today=$(shell date --utc +%Y%m%d)
endif

t15 = $(shell printf "%02d" `expr 15 - ${base_hh_utc}`)
grib_1500z = nam.t${base_hh_utc}z.awip3d$(t15).tm00.grib2
t18 = $(shell printf "%02d" `expr 18 - ${base_hh_utc}`)
grib_1800z = nam.t${base_hh_utc}z.awip3d$(t18).tm00.grib2
t21 = $(shell printf "%02d" `expr 21 - ${base_hh_utc}`)
grib_2100z = nam.t${base_hh_utc}z.awip3d$(t21).tm00.grib2
t24 = $(shell printf "%02d" `expr 24 - ${base_hh_utc}`)
grib_2400z = nam.t${base_hh_utc}z.awip3d$(t24).tm00.grib2

all: grib

grib: file_available ${grib_1200z} 
${grib_1200z}: mark_file
	$(WGET) $(WGET_OPTION) \
		$(GRIB_FTP_SITE)$(GRIB_FTP_DIR)/nam.$(utc_today)/${grib_1200z}
	$(WGET) $(WGET_OPTION) \
		$(GRIB_FTP_SITE)$(GRIB_FTP_DIR)/nam.$(utc_today)/$(grib_1500z)
	$(WGET) $(WGET_OPTION) \
		$(GRIB_FTP_SITE)$(GRIB_FTP_DIR)/nam.$(utc_today)/$(grib_1800z)
	$(WGET) $(WGET_OPTION) \
		$(GRIB_FTP_SITE)$(GRIB_FTP_DIR)/nam.$(utc_today)/$(grib_2100z)
	$(WGET) $(WGET_OPTION) \
		$(GRIB_FTP_SITE)$(GRIB_FTP_DIR)/nam.$(utc_today)/$(grib_2400z)

file_available:
	touch --date="`date --utc +%F` 00:00Z" mark_file

clean: file_available
	$(RM) nam.t${base_hh_utc}z.awip3d??.tm00.grib2* *~
