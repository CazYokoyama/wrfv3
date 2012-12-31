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
export ENV_NCL_FILENAME=${BASEDIR}/WRFV3/run/wrfout_d02_2012-12-16_12:00:00
export FILEDATE=$(shell echo ${ENV_NCL_FILENAME} | cut -d _ -f 3)
export FILETIME=$(shell echo ${ENV_NCL_FILENAME} | cut -d _ -f 4)
export localhh=$(shell echo ${FILETIME} | cut -d : -f 1)
export localmin=$(shell echo ${FILETIME} | cut -d : -f 2)
export localdow=$(shell date -d ${FILEDATE} +%a)
export localday=$(shell date -d ${FILEDATE} +%-d)
export localmon=$(shell date -d ${FILEDATE} +%b)
export localyyyy=$(shell date -d ${FILEDATE} +%Y)
export localtimeid=$(shell date -d ${FILEDATE} +%Z)
export filehh=$(shell date -u -d ${FILETIME} +%H)
export filemin=$(shell date -u -d ${FILETIME} +%M)
export file_creat_hr=$(shell ls -l --time-style="+%H" ${ENV_NCL_FILENAME} | cut -d " " -f 6)
export file_creat_mn=$(shell ls -l --time-style="+%M" ${ENV_NCL_FILENAME} | cut -d " " -f 6)
export fcstperiodprt="\?\?"
export ztime='????'
export ENV_NCL_DATIME=$(shell echo Day= ${localyyyy} ${localmon} ${localday} ${localdow} \
ValidLST= ${localhh}${localmin} ${localtimeid} ValidZ= ${filehh}${filemin} \
Fcst= ${fcstperiodprt} Init= ${fcstperiodprt})
export ENV_NCL_ID=$(shell printf "Valid %02d%02d %s ~Z75~\(%02d%02dZ\)~Z~ %s %s %s %d ~Z75~[%shrFcst@%sz]~Z~" \
${localhh} ${localmin} ${localtimeid} ${filehh} ${filemin} ${localdow} ${localday} ${localmon} ${localyyyy} ${fcstperiodprt} ${ztime})
export ENV_NCL_PARAMS="mslpress:sfcwind0:sfcwind:sfcwind2:blwind:\
bltopwind:dbl:experimental1:sfctemp:zwblmaxmin:blicw:hbl:hwcrit:\
dwcrit: wstar:bsratio:sfcshf:zblcl:zblcldif:\
zblclmask:blcwbase:press1000:press950:press850:press700:press500:\
bltopvariab:wblmaxmin:zwblmaxmin:blwindshear:sfctemp:sfcdewpt:cape:\
wrf=HGT:wstar_bsratio:bsratio_bsratio:\
blcloudpct:sfcsunpct:zsfclcl:zsfclcldif:zsfclclmask:\
hglider:stars:\
sounding1:sounding2:sounding3:sounding4:sounding5:sounding6:sounding7:\
sounding8:sounding9"
SCP = scp
SCP_OPTION = -q
SCP_DEST = caztech:/var/www/html/RASP/GM/${location}

all: copy_to_website

${ENV_NCL_OUTDIR}/png_created_${FILEDATE}_${FILEDATE}:
	@$(RM) -rf ${ENV_NCL_OUTDIR}; mkdir -p ${ENV_NCL_OUTDIR}
	cd GM; ${NCL_COMMAND} -n -p wrf2gm.ncl
	touch ${ENV_NCL_OUTDIR}/png_created_${FILEDATE}_${FILEDATE}

copy_to_website: ${ENV_NCL_OUTDIR}/png_created_${FILEDATE}_${FILEDATE}
	$(SCP) $(SCP_OPTION) ${ENV_NCL_OUTDIR}/*.png $(SCP_DEST)

clean:
	@$(RM) -rf ${ENV_NCL_OUTDIR}
