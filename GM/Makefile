export ENV_NCL_FILENAME=${WRFOUT_DIR}/$(WRFOUT_NAME)
FILEDATE = $(shell echo $(ENV_NCL_FILENAME) | cut -d_ -f3)
FILETIME = $(shell echo $(ENV_NCL_FILENAME) | cut -d_ -f4)
utc_hh = $(shell date --date="$(FILEDATE) $(FILETIME)" +%H)
utc_day = $(shell date --date=$(FILEDATE) +%-d)
time_diff = $(shell date +%:::z)
local_24 = $(shell expr $(utc_hh) + $(time_diff) + 24)
localhh = $(shell \
if [ $(local_24) -ge 24 ]; then \
	expr $(local_24) - 24; \
else \
	echo $(local_24); \
fi)
localday = $(shell \
if [ $(local_24) -ge 24 ]; then \
	date --date=$(FILEDATE) +%-d; \
else \
	date --date=yesterday$(FILEDATE) +%-d; \
fi)
localdow = $(shell \
if [ $(local_24) -ge 24 ]; then \
	date --date=$(FILEDATE) +%a; \
else \
	date --date=yesterday$(FILEDATE) +%a; \
fi)
localmin = $(shell echo $(FILETIME) | cut -d : -f 2)
localmon = $(shell date -d $(FILEDATE) +%b)
localyyyy = $(shell date -d $(FILEDATE) +%Y)
localtimeid = $(shell date -d $(FILEDATE) +%Z)
filehh = $(shell date -u -d $(FILETIME) +%H)
filemin = $(shell date -u -d $(FILETIME) +%M)
fcstperiodprt = $(shell expr $(localhh) + 24 - 16)
ztime = 1600
export ENV_NCL_ID=$(shell printf "Valid %02d%02d %s ~Z75~(%02d%02dZ)~Z~ %s %s %s %d ~Z75~[%shrFcst@%sz]~Z~" \
$(localhh) $(localmin) $(localtimeid) $(filehh) $(filemin) $(localdow) $(localday) $(localmon) $(localyyyy) \
$(fcstperiodprt) $(ztime))
TIME_ID = $(FILEDATE)_$(shell echo $(FILETIME) | tr ":" "-")
export ENV_NCL_OUTDIR=${NCL_OUTDIR}/$(TIME_ID)
SCP = scp
SCP_OPTION = -q
SCP_DEST_SITE = caztech
SCP_DEST_DIR = /var/www/html/RASP/GM/${flying_field}-1200z

all: copy_to_website

${ENV_NCL_OUTDIR}/png_created_$(TIME_ID): ${WRFOUT_DIR}/wrf_done
	@$(RM) ${ENV_NCL_OUTDIR}/png_created_$(TIME_ID)
	@$(RM) -r ${ENV_NCL_OUTDIR}; mkdir -p ${ENV_NCL_OUTDIR}
	${NCL_COMMAND} -n -p ${BASEDIR}/GM/wrf2gm.ncl 2>&1 >$(TIME_ID).log && \
	touch ${ENV_NCL_OUTDIR}/png_created_$(TIME_ID)

copy_to_website: ${ENV_NCL_OUTDIR}/png_created_$(TIME_ID)
	if ping -qc1 $(SCP_DEST_SITE) >/dev/null; then \
		$(SCP) $(SCP_OPTION) ${ENV_NCL_OUTDIR}/*.png $(SCP_DEST_SITE):$(SCP_DEST_DIR); \
	fi

clean:
	@$(RM) -r ${ENV_NCL_OUTDIR}
