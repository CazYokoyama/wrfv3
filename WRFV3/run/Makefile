all: wrf_done

wrf_done: wrfinput_d01 wrfinput_d02
	ulimit -s unlimited; \
	./wrf.exe && touch wrf_done

wrfinput_d01 wrfinput_d02: ../../domains/${FLYING_FIELD}/metgrid_done
	$(RM) met_em.d0* namelist.input
	ln -s ../../domains/${FLYING_FIELD}/met_em.d0* .
	cp ../../domains/${FLYING_FIELD}/namelist.input .
	sed -i -e "/start_year/s/2000/$(utc_yyyy)/g" namelist.input
	sed -i -e "/start_month/s/01/$(utc_mon)/g" namelist.input
	sed -i -e "/start_day/s/24/$(utc_today)/g" namelist.input
	sed -i -e "/end_year/s/2000/$(utc_yyyy)/g" namelist.input
	sed -i -e "/end_month/s/01/$(utc_mon)/g" namelist.input
	sed -i -e "/end_day/s/25/$(utc_tomorrow)/g" namelist.input
	sed -i -e "/end_hour/s/12/00/g" namelist.input
	sed -i -e "/num_metgrid_levels/s/27/40/" namelist.input
	./real.exe

clean:
	$(RM) wrf_done wrfout_d* met_em.d0* namelist.input wrfinput_d*
