ifndef flying_field
	export flying_field=NorthPlains
endif

export BASEDIR=$(shell pwd)
export LD_LIBRARY_PATH=/usr/local/lib:${BASEDIR}/GM/LIB_NCL_JACK_FORTRAN/CL1M1-2M1
export GETVAR=DRJACK
export FLYING_FIELD=$(shell echo ${flying_field} | tr [a-z] [A-Z])
export ENV_NCL_REGIONNAME=${FLYING_FIELD}
export NCL_OUTDIR=${BASEDIR}/domains/${FLYING_FIELD}/chart
export PROJECTION=Mercator
export WRFOUT_DIR=${BASEDIR}/WRFV3/run

export NCARG_ROOT=/usr
export NCL_COMMAND=${NCARG_ROOT}/bin/ncl
export NCARG_DATABASE=${NCARG_ROOT}/lib64/ncarg/database
export NCARG_FONTCAPS=${NCARG_ROOT}/lib64/ncarg/fontcaps
export NCARG_RANGS=/usr/local/lib/ncarg/database/rangs
export GMIMAGESIZE=1600
export ENV_NCL_PARAMS="mslpress:sfcwind0:sfcwind:sfcwind2:blwind:bltopwind:dbl:experimental1:sfctemp:zwblmaxmin:blicw:hbl:hwcrit:dwcrit:wstar:bsratio:sfcshf:zblcl:zblcldif:zblclmask:blcwbase:press1000:press950:press850:press700:press500:bltopvariab:wblmaxmin:zwblmaxmin:blwindshear:sfctemp:sfcdewpt:cape:rain1:wrf=HGT:wstar_bsratio:bsratio_bsratio:blcloudpct:sfcsunpct:zsfclcl:zsfclcldif:zsfclclmask:hglider:stars:sounding1:sounding2:sounding3:sounding4:sounding5:sounding6:sounding7:sounding8:sounding9"
WRF_RUN = ${BASEDIR}/WRFV3/run

current_hh = $(shell date --utc +%H)
ifndef base_hh_utc
	export base_hh_utc=$(shell printf "%02d" `expr \( \( $(current_hh) - 1 \) / 6 \) \* 6`)
endif
export yesterday = $(shell \
if [ $(current_hh) -le $(base_hh_utc) ]; then \
	echo true; \
else \
	echo false; \
fi)
ifeq (${yesterday},true)
	utc_today=$(shell date --utc --date=yesterday +%F)
	utc_tomorrow=$(shell date --utc --date=today +%F)
else
	utc_today=$(shell date --utc +%F)
	utc_tomorrow=$(shell date --utc --date=tomorrow +%F)
endif
WRFOUT_1700Z = wrfout_d02_$(utc_today)_17:00:00
WRFOUT_1800Z = wrfout_d02_$(utc_today)_18:00:00
WRFOUT_1900Z = wrfout_d02_$(utc_today)_19:00:00
WRFOUT_2000Z = wrfout_d02_$(utc_today)_20:00:00
WRFOUT_2100Z = wrfout_d02_$(utc_today)_21:00:00
WRFOUT_2200Z = wrfout_d02_$(utc_today)_22:00:00
WRFOUT_2300Z = wrfout_d02_$(utc_today)_23:00:00
WRFOUT_2400Z = wrfout_d02_$(utc_tomorrow)_00:00:00

export prediction_hours=$(shell printf "%02d" `expr 12 - ${base_hh_utc}`)
export grib_1200z=nam.t${base_hh_utc}z.awip3d${prediction_hours}.tm00.grib2

all: ncl

ncl chart: 1700Z 1800Z 1900Z 2000Z 2100Z 2200Z 2300Z 2400Z
1700Z: $(WRF_RUN)/wrf_done
	$(MAKE) -C GM WRFOUT_NAME=$(WRFOUT_1700Z) all

1800Z: $(WRF_RUN)/wrf_done
	$(MAKE) -C GM WRFOUT_NAME=$(WRFOUT_1800Z) all

1900Z: $(WRF_RUN)/wrf_done
	$(MAKE) -C GM WRFOUT_NAME=$(WRFOUT_1900Z) all

2000Z: $(WRF_RUN)/wrf_done
	$(MAKE) -C GM WRFOUT_NAME=$(WRFOUT_2000Z) all

2100Z: $(WRF_RUN)/wrf_done
	$(MAKE) -C GM WRFOUT_NAME=$(WRFOUT_2100Z) all

2200Z: $(WRF_RUN)/wrf_done
	$(MAKE) -C GM WRFOUT_NAME=$(WRFOUT_2200Z) all

2300Z: $(WRF_RUN)/wrf_done
	$(MAKE) -C GM WRFOUT_NAME=$(WRFOUT_2300Z) all

2400Z: $(WRF_RUN)/wrf_done
	$(MAKE) -C GM WRFOUT_NAME=$(WRFOUT_2400Z) all

wrf: $(WRF_RUN)/wrf_done
$(WRF_RUN)/wrf_done: ${BASEDIR}/domains/${FLYING_FIELD}/metgrid_done
	$(MAKE) -C $(WRF_RUN) wrf_done

wps: ${BASEDIR}/domains/${FLYING_FIELD}/metgrid_done
${BASEDIR}/domains/${FLYING_FIELD}/metgrid_done: grib_dir/${grib_1200z}
	$(MAKE) -C ${BASEDIR}/domains/${FLYING_FIELD} metgrid_done

grib grib_dir/${grib_1200z}:
	$(MAKE) -C ${BASEDIR}/grib_dir all

clean-grib:
	$(MAKE) -C ${BASEDIR}/grib_dir clean

clean-wps:
	$(MAKE) -C ${BASEDIR}/domains/${FLYING_FIELD} clean

clean-geogrid:
	$(MAKE) -C ${BASEDIR}/domains/${FLYING_FIELD} clean-geogrid

clean-wrf:
	$(MAKE) -C $(WRF_RUN) clean

clean-chart:
	$(MAKE) -C ${BASEDIR}/GM WRFOUT_NAME=$(WRFOUT_1700Z) clean

clean-grib-too: clean clean-grib

clean: clean-wps clean-wrf clean-chart
	$(RM) -r *~ *.log
