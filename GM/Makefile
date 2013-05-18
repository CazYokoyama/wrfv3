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
localtimeid = $(shell date +%Z)
filehh = $(shell date -u -d $(FILETIME) +%H)
filemin = $(shell date -u -d $(FILETIME) +%M)
tmp = $(shell expr $(filehh) - ${base_hh_utc})
fcstperiodprt = $(shell \
if [ $(tmp) -gt 0 ]; then \
	echo $(tmp); \
else \
	expr $(tmp) + 24; \
fi)
export ENV_NCL_ID=$(shell printf "Valid %02d%02d %s ~Z75~(%02d%02dZ)~Z~ %s %s %s %d ~Z75~[%shrFcst@%s00z]~Z~" \
$(localhh) $(localmin) $(localtimeid) $(filehh) $(filemin) $(localdow) $(localday) $(localmon) $(localyyyy) \
$(fcstperiodprt) ${base_hh_utc})
TIME_ID = $(FILEDATE)_$(shell echo $(FILETIME) | tr ":" "-")
export NCL_OUTDIR=${BASEDIR}/domains/${FLYING_FIELD}/chart/${flying_field}-${base_hh_utc}00z
export ENV_NCL_OUTDIR=${NCL_OUTDIR}

all: ${ENV_NCL_OUTDIR}/png_created_$(TIME_ID)

${ENV_NCL_OUTDIR}/png_created_$(TIME_ID): ${WRFOUT_DIR}/wrf_done
	@$(RM) ${ENV_NCL_OUTDIR}/png_created_$(TIME_ID)
	@$(RM) -r ${ENV_NCL_OUTDIR}/*.png
	${NCL_COMMAND} -n -p ${BASEDIR}/GM/wrf2gm.ncl 2>&1 >$(TIME_ID).log && \
	touch ${ENV_NCL_OUTDIR}/png_created_$(TIME_ID)

copy_to_website:
	for n in {1..100}; do \
		if ncftpput -f ~caz/.1202.us \
		  -t 60 -V -d ncftpput-$(TIME_ID).log \
		  /RASP/${flying_field}/chart/${flying_field}-${base_hh_utc}00z \
		  ${ENV_NCL_OUTDIR}/*.png; then \
			break;\
		fi;\
		sleep $${n};\
	done

clean:
	@$(RM) -f ${NCL_OUTDIR}/* 20??-*-00-00.log *~ ncftpput-*.log ${ENV_NCL_OUTDIR}/png_created_$(TIME_ID)
