export ENV_NCL_FILENAME=${WRFOUT_DIR}/$(WRFOUT_NAME)
export FILEDATE=$(shell echo $(ENV_NCL_FILENAME) | cut -d _ -f 3)
export FILETIME=$(shell echo $(ENV_NCL_FILENAME) | cut -d _ -f 4)
export localhh=$(shell echo ${FILETIME} | cut -d : -f 1)
export localmin=$(shell echo ${FILETIME} | cut -d : -f 2)
export localdow=$(shell date -d ${FILEDATE} +%a)
export localday=$(shell date -d ${FILEDATE} +%-d)
export localmon=$(shell date -d ${FILEDATE} +%b)
export localyyyy=$(shell date -d ${FILEDATE} +%Y)
export localtimeid=$(shell date -d ${FILEDATE} +%Z)
export filehh=$(shell date -u -d ${FILETIME} +%H)
export filemin=$(shell date -u -d ${FILETIME} +%M)
export file_creat_hr=$(shell ls -l --time-style="+%H" $(ENV_NCL_FILENAME) | cut -d " " -f 6)
export file_creat_mn=$(shell ls -l --time-style="+%M" $(ENV_NCL_FILENAME) | cut -d " " -f 6)
export fcstperiodprt="\?\?"
export ztime='????'
export ENV_NCL_ID=$(shell printf "Valid %02d%02d %s ~Z75~\(%02d%02dZ\)~Z~ %s %s %s %d ~Z75~[%shrFcst@%sz]~Z~" \
${localhh} ${localmin} ${localtimeid} ${filehh} ${filemin} ${localdow} ${localday} ${localmon} ${localyyyy} \
${fcstperiodprt} ${ztime})
TIME_ID = ${FILEDATE}_$(shell echo ${FILETIME} | tr ":" "-")
export ENV_NCL_OUTDIR=${NCL_OUTDIR}/$(TIME_ID)
SCP = scp
SCP_OPTION = -q
SCP_DEST_SITE = caztech
SCP_DEST_DIR = /var/www/html/RASP/GM/${flying_field}

all: copy_to_website

${ENV_NCL_OUTDIR}/png_created_$(TIME_ID):
	@$(RM) -r ${ENV_NCL_OUTDIR}; mkdir -p ${ENV_NCL_OUTDIR}
	${NCL_COMMAND} -n -p ${BASEDIR}/GM/wrf2gm.ncl 2>&1 >$(TIME_ID).log && \
	touch ${ENV_NCL_OUTDIR}/png_created_$(TIME_ID)

copy_to_website: ${ENV_NCL_OUTDIR}/png_created_$(TIME_ID)
	if ping -qc1 $(SCP_DEST_SITE) >/dev/null; then \
		$(SCP) $(SCP_OPTION) ${ENV_NCL_OUTDIR}/*.png $(SCP_DEST_SITE):$(SCP_DEST_DIR); \
	fi

clean:
	@$(RM) -r ${ENV_NCL_OUTDIR}
