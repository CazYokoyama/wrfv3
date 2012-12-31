export LOCATION=NORTHPLAINS

export BASEDIR=$(shell pwd)
export LD_LIBRARY_PATH=/usr/local/lib:${BASEDIR}/GM/LIB_NCL_JACK_FORTRAN/CL1M1-2M1
export GETVAR=DRJACK
export ENV_NCL_REGIONNAME=${LOCATION}
export ENV_NCL_OUTDIR=${BASEDIR}/domains/${LOCATION}/out
export PROJECTION=Lambert

all:
	rm -rf ${ENV_NCL_OUTDIR}
	cd GM; ./test-NEW.sh ${BASEDIR}/WRFV3/run/wrfout_d02_2012-12-16_12:00:00
