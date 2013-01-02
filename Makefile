export flying_field=northplains

WRFOUT_1800Z = wrfout_d02_2012-12-16_18:00:00
WRFOUT_2100Z = wrfout_d02_2012-12-16_21:00:00
WRFOUT_2400Z = wrfout_d02_2012-12-17_00:00:00

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
zblclmask:blcwbase:\
bltopvariab:wblmaxmin:zwblmaxmin:blwindshear:sfctemp:sfcdewpt:cape:\
wstar_bsratio:bsratio_bsratio:\
blcloudpct:sfcsunpct:zsfclcl:zsfclcldif:zsfclclmask:\
hglider:stars:\
sounding1:sounding2:sounding3:sounding4:sounding5:sounding6:sounding7:\
sounding8:sounding9"
#wrf=HGT:wstar_bsratio:bsratio_bsratio:\ # wrf=HGT produce an error
#zblclmask:blcwbase:press1000:press950:press850:press700:press500:\ # press*: gm convert: Request did not return an image.
WRF_RUN = ${BASEDIR}/WRFV3/run

#utc_yyyy=$(shell date --utc +%Y)
#utc_mon=$(shell date --utc +%m)
#utc_today=$(shell date --utc +%d)
#utc_tomorrow=$(shell date --utc --date=tomorrow +%d)
utc_yyyy=2012
utc_mon=12
utc_today=16
utc_tomorrow=17

all: ncl

ncl: 1800Z 2100Z 2400Z
1800Z: $(WRF_RUN)/wrf_done
	$(MAKE) -C GM WRFOUT_NAME=$(WRFOUT_1800Z) all

2100Z:  $(WRF_RUN)/wrf_done
	$(MAKE) -C GM WRFOUT_NAME=$(WRFOUT_2100Z) all

2400Z:  $(WRF_RUN)/wrf_done
	$(MAKE) -C GM WRFOUT_NAME=$(WRFOUT_2400Z) all

wrf: $(WRF_RUN)/wrf_done
$(WRF_RUN)/wrf_done: $(WRF_RUN)/wrfinput_d02
	cd $(WRF_RUN); ulimit -s unlimited; ../main/wrf.exe && \
	touch $(WRF_RUN)/wrf_done

real: $(WRF_RUN)/wrfinput_d02
$(WRF_RUN)/wrfinput_d02: metgrid
	cd $(WRF_RUN); \
	$(RM) met_em.d0*; \
	ln -s ${BASEDIR}/domains/${FLYING_FIELD}/met_em.d0* .; \
	rm -f namelist.input; \
	cp ${BASEDIR}/domains/${FLYING_FIELD}/namelist.input .; \
	sed -i -e "/start_year/s/2000/$(utc_yyyy)/g" namelist.input; \
	sed -i -e "/start_month/s/01/$(utc_mon)/g" namelist.input; \
	sed -i -e "/start_day/s/24/$(utc_today)/g" namelist.input; \
	sed -i -e "/end_year/s/2000/$(utc_yyyy)/g" namelist.input; \
	sed -i -e "/end_month/s/01/$(utc_mon)/g" namelist.input; \
	sed -i -e "/end_day/s/25/$(utc_tomorrow)/g" namelist.input; \
	sed -i -e "/end_hour/s/12/00/g" namelist.input; \
	sed -i -e "/num_metgrid_levels/s/27/40/" namelist.input; \
	../main/real.exe

metgrid: ${BASEDIR}/domains/${FLYING_FIELD}/metgrid_done
${BASEDIR}/domains/${FLYING_FIELD}/metgrid_done: ${BASEDIR}/domains/${FLYING_FIELD}/geo_em.d02.nc
	cd ${BASEDIR}/domains/${FLYING_FIELD}; \
	$(RM) met_em.d0?.*:00:00.nc metgrid_done; \
	${BASEDIR}/WPS/metgrid.exe && \
	touch metgrid_done

clean:
	cd ${BASEDIR}/domains/${FLYING_FIELD}; $(RM) met_em.d0?.*:00:00.nc metgrid_done 
	$(RM) $(WRF_RUN)/wrf_done $(WRF_RUN)/wrfout_d*
	$(RM) -r ${NCL_OUTDIR}
