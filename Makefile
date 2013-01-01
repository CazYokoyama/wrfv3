export flying_field=northplains

export BASEDIR=$(shell pwd)
export LD_LIBRARY_PATH=/usr/local/lib:${BASEDIR}/GM/LIB_NCL_JACK_FORTRAN/CL1M1-2M1
export GETVAR=DRJACK
export FLYING_FIELD=$(shell echo ${flying_field} | tr [a-z] [A-Z])
export ENV_NCL_REGIONNAME=${FLYING_FIELD}
export ENV_NCL_OUTDIR=${BASEDIR}/domains/${FLYING_FIELD}/out
export PROJECTION=Lambert

export NCARG_ROOT=/usr
export NCL_COMMAND=${NCARG_ROOT}/bin/ncl
export NCARG_RANGS=/usr/local/lib/ncarg/database/rangs
export GMIMAGESIZE=1600
export ENV_NCL_PARAMS="mslpress:sfcwind0:sfcwind:sfcwind2:blwind:\
bltopwind:dbl:experimental1:sfctemp:zwblmaxmin:blicw:hbl:hwcrit:\
dwcrit: wstar:bsratio:sfcshf:zblcl:zblc3ldif:\
zblclmask:blcwbase:press1000:press950"
#zblclmask:blcwbase:press1000"
#zblclmask:blcwbase"
#zblclmask:blcwbase:press1000:press950"
#zblclmask:blcwbase:press1000:press950:press850:press700:press500"
#zblclmask:blcwbase:press1000:press950:press850:press700:press500:\
#bltopvariab:wblmaxmin:zwblmaxmin:blwindshear:sfctemp:sfcdewpt:cape:\
#wrf=HGT:wstar_bsratio:bsratio_bsratio:\
#blcloudpct:sfcsunpct:zsfclcl:zsfclcldif:zsfclclmask:\
#hglider:stars:\
#sounding1:sounding2:sounding3:sounding4:sounding5:sounding6:sounding7:\
#sounding8:sounding9"

all: 
	@$(RM) -rf ${ENV_NCL_OUTDIR}; mkdir -p ${ENV_NCL_OUTDIR}
	$(MAKE) -C GM ENV_NCL_FILENAME=${BASEDIR}/WRFV3/run/wrfout_d02_2012-12-16_12:00:00 all
	$(MAKE) -C GM ENV_NCL_FILENAME=${BASEDIR}/WRFV3/run/wrfout_d02_2012-12-16_13:00:00 all

clean:
	$(MAKE) -C GM ENV_NCL_FILENAME=${BASEDIR}/WRFV3/run/wrfout_d02_2012-12-16_12:00:00 clean


