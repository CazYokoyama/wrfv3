utc_today=$(shell date --utc +%Y-%m-%d)
utc_tomorrow=$(shell date --utc --date=tomorrow +%Y-%m-%d)

all: metgrid_done

metgrid: metgrid_done
metgrid_done: geo_em.d02.nc ungrib_done
	@$(RM) met_em.d0?.*:00:00.nc metgrid_done
	@sed -i -e "/opt_output_from_metgrid_path/s@domain-wizard/NorthPlains@NORTHPLAINS@g" namelist.wps
	@sed -i -e "/opt_metgrid_tbl_path/s@domain-wizard/NorthPlains@NORTHPLAINS@g" namelist.wps
	../../WPS/metgrid.exe >metgrid.stdout
	@grep -q "Successful completion" metgrid.log && touch metgrid_done

geogrid:  geo_em.d02.nc
geo_em.d02.nc:
	@cp ../domain-wizard/NorthPlains/namelist.wps .
	@sed -i -e "/opt_output_from_geogrid_path/s@domain-wizard/NorthPlains@NORTHPLAINS@g" namelist.wps
	@sed -i -e "/opt_geogrid_tbl_path/s@domain-wizard/NorthPlains@NORTHPLAINS@g" namelist.wps
	../../WPS/geogrid.exe >geogrid.stdout
	@$(RM) namelist.wps

ungrib: ungrib_done
ungrib_done: ../../grib_dir/nam.t00z.awip3d12.tm00.grib2 ../domain-wizard/NorthPlains/namelist.wps
	@$(RM) Vtable FILE:*
	@ln -sf ../../WPS/ungrib/Variable_Tables/Vtable.NAM Vtable
	@../../WPS/link_grib.csh ../../grib_dir/nam.t00z.awip3d
	@cp ../domain-wizard/NorthPlains/namelist.wps .
	sed -i -e "/start_date/s/....-..-.._..:00:00/$(utc_today)_12:00:00/g" namelist.wps
	sed -i -e "/end_date/s/....-..-.._00:00:00/$(utc_tomorrow)_00:00:00/g" namelist.wps
	../../WPS/ungrib.exe >ungrib.stdout
	@grep -q "Successful completion" ungrib.log && touch ungrib_done

clean-metgrid:
	@$(RM) met_em.d0?.*:00:00.nc metgrid_done metgrid.stdout metgrid.log

clean-ungrib:
	@$(RM) FILE:* ungrib_done Vtable GRIBFILE.* namelist.wps ungrib.log ungrib.stderr ungrib.stdout

clean-geogrid:
	@$(RM) geo_em.d0?.nc geogrid.stdout geogrid.log

clean: clean-metgrid clean-ungrib
	@$(RM) *~
