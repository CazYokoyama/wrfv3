export flying_field=northplains

export BASEDIR=$(shell pwd)
export LD_LIBRARY_PATH=/usr/local/lib:${BASEDIR}/GM/LIB_NCL_JACK_FORTRAN/CL1M1-2M1
export GETVAR=DRJACK
export FLYING_FIELD=$(shell echo ${flying_field} | tr [a-z] [A-Z])
export ENV_NCL_REGIONNAME=${FLYING_FIELD}
export NCL_OUTDIR=${BASEDIR}/domains/${FLYING_FIELD}/out
export PROJECTION=Lambert
export WRFOUT_DIR=${BASEDIR}/WRFV3/run

export NCARG_ROOT=/usr
export NCL_COMMAND=${NCARG_ROOT}/bin/ncl
export NCARG_RANGS=/usr/local/lib/ncarg/database/rangs
export GMIMAGESIZE=1600
export ENV_NCL_PARAMS="mslpress:sfcwind0:sfcwind:sfcwind2:blwind:\
bltopwind:dbl:experimental1:sfctemp:zwblmaxmin:blicw:hbl:hwcrit:\
dwcrit: wstar:bsratio:sfcshf:zblcl:zblcldif:\
zblclmask:blcwbase:press1000:press950:press850:press700:press500:\
bltopvariab:wblmaxmin:zwblmaxmin:blwindshear:sfctemp:sfcdewpt:cape:\
rain1:wstar_bsratio:bsratio_bsratio:\
blcloudpct:sfcsunpct:zsfclcl:zsfclcldif:zsfclclmask:\
hglider:stars:\
sounding1:sounding2:sounding3:sounding4:sounding5:sounding6:sounding7:\
sounding8:sounding9"
#wrf=HGT:wstar_bsratio:bsratio_bsratio:\ # wrf=HGT produce an error
#zblclmask:blcwbase:press1000:press950:press850:press700:press500:\ # press*: gm convert: Request did not return an image.
WRF_RUN = ${BASEDIR}/WRFV3/run

export utc_yyyy=$(shell date --utc +%Y)
export utc_mon=$(shell date --utc +%m)
export utc_today=$(shell date --utc +%d)
export utc_tomorrow=$(shell date --utc --date=tomorrow +%d)

WRFOUT_1800Z = wrfout_d02_$(utc_yyyy)-$(utc_mon)-$(utc_today)_18:00:00
WRFOUT_2100Z = wrfout_d02_$(utc_yyyy)-$(utc_mon)-$(utc_today)_21:00:00
WRFOUT_2400Z = wrfout_d02_$(utc_yyyy)-$(utc_mon)-$(utc_tomorrow)_00:00:00

WGET = /usr/bin/wget
WGET_OPTION = -q
GRIB_FTP_SITE = ftp://ftpprd.ncep.noaa.gov
GRIB_FTP_DIR = /pub/data/nccf/com/nam/prod

all: ncl

ncl: 1800Z 2100Z 2400Z
1800Z: $(WRF_RUN)/wrf_done
	$(MAKE) -C GM WRFOUT_NAME=$(WRFOUT_1800Z) all

2100Z:  $(WRF_RUN)/wrf_done
	$(MAKE) -C GM WRFOUT_NAME=$(WRFOUT_2100Z) all

2400Z:  $(WRF_RUN)/wrf_done
	$(MAKE) -C GM WRFOUT_NAME=$(WRFOUT_2400Z) all

wrf: $(WRF_RUN)/wrf_done
$(WRF_RUN)/wrf_done: ${BASEDIR}/domains/${FLYING_FIELD}/metgrid_done
	$(MAKE) -C $(WRF_RUN) wrf_done

wps: ${BASEDIR}/domains/${FLYING_FIELD}/metgrid_done
${BASEDIR}/domains/${FLYING_FIELD}/metgrid_done: ${BASEDIR}/grib/nam.t00z.awip3d12.tm00.grib2
	$(MAKE) -C ${BASEDIR}/domains/${FLYING_FIELD} metgrid_done

grib: ${BASEDIR}/grib/nam.t00z.awip3d12.tm00.grib2
${BASEDIR}/grib/nam.t00z.awip3d12.tm00.grib2:
	cd ${BASEDIR}/grib; $(RM) nam.t00z.awip3d??.tm00.grib2; \
	$(WGET) $(WGET_OPTION) \
		$(GRIB_FTP_SITE)$(GRIB_FTP_DIR)/nam.$(utc_yyyy)$(utc_mon)$(utc_today)/nam.t00z.awip3d12.tm00.grib2; \
	$(WGET) $(WGET_OPTION) \
		$(GRIB_FTP_SITE)$(GRIB_FTP_DIR)/nam.$(utc_yyyy)$(utc_mon)$(utc_today)/nam.t00z.awip3d15.tm00.grib2; \
	$(WGET) $(WGET_OPTION) \
		$(GRIB_FTP_SITE)$(GRIB_FTP_DIR)/nam.$(utc_yyyy)$(utc_mon)$(utc_today)/nam.t00z.awip3d18.tm00.grib2; \
	$(WGET) $(WGET_OPTION) \
		$(GRIB_FTP_SITE)$(GRIB_FTP_DIR)/nam.$(utc_yyyy)$(utc_mon)$(utc_today)/nam.t00z.awip3d21.tm00.grib2; \
	$(WGET) $(WGET_OPTION) \
		$(GRIB_FTP_SITE)$(GRIB_FTP_DIR)/nam.$(utc_yyyy)$(utc_mon)$(utc_today)/nam.t00z.awip3d24.tm00.grib2;

clean_grib_too: clean
	cd ${BASEDIR}/grib; $(RM) nam.t00z.awip3d??.tm00.grib2

clean:
	$(MAKE) -C $(WRF_RUN) clean
	$(MAKE) -C ${BASEDIR}/domains/${FLYING_FIELD} clean
	$(RM) -r ${NCL_OUTDIR}
	$(RM) -r *~ *.log
