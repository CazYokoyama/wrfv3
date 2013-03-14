#utc_today_yyyy=$(shell date --utc +%Y)
#utc_today_mon=$(shell date --utc +%m)
#utc_today_date=$(shell date --utc +%d)
#utc_tomorrow_yyyy=$(shell date --utc --date=tomorrow +%Y)
#utc_tomorrow_mon=$(shell date --utc --date=tomorrow +%m)
#utc_tomorrow_date=$(shell date --utc --date=tomorrow +%d)
utc_today_yyyy=$(shell date --utc --date=yesterday +%Y)
utc_today_mon=$(shell date --utc --date=yesterday +%m)
utc_today_date=$(shell date --utc --date=yesterday +%d)
utc_tomorrow_yyyy=$(shell date --utc --date=today +%Y)
utc_tomorrow_mon=$(shell date --utc --date=today +%m)
utc_tomorrow_date=$(shell date --utc --date=today +%d)

all: wrf_done

wrf: wrf_done
wrf_done: wrfinput_d02
	ulimit -s unlimited; \
	./wrf.exe >wrf.log && touch wrf_done

real: wrfinput_d01 wrfinput_d02
wrfinput_d01 wrfinput_d02: ../../domains/${FLYING_FIELD}/metgrid_done
	@$(RM) wrf_done
	@$(RM) met_em.d0* namelist.input
	@ln -s ../../domains/${FLYING_FIELD}/met_em.d0* .
	@cp ../../domains/${FLYING_FIELD}/namelist.input .
	@sed -i -e "/start_year/s/....,/$(utc_today_yyyy),/g" namelist.input
	@sed -i -e "/start_month/s/..,/$(utc_today_mon),/g" namelist.input
	@sed -i -e "/start_day/s/..,/$(utc_today_date),/g" namelist.input
	@sed -i -e "/end_year/s/....,/$(utc_tomorrow_yyyy),/g" namelist.input
	@sed -i -e "/end_month/s/..,/$(utc_tomorrow_mon),/g" namelist.input
	@sed -i -e "/end_day/s/..,/$(utc_tomorrow_date),/g" namelist.input
	@sed -i -e "/end_hour/s/12/00/g" namelist.input
	@sed -i -e "/num_metgrid_levels/s/27/40/" namelist.input
	./real.exe >real.stdout

clean:
	@$(RM) wrf_done wrfout_d*
	@$(RM) met_em.d0* namelist.input wrfinput_d* wrfbdy_d01
	@$(RM) *~ *.log
