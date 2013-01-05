all: metgrid_done

metgrid: metgrid_done
metgrid_done: geo_em.d01.nc geo_em.d02.nc ungrib_done
	$(RM) met_em.d0?.*:00:00.nc metgrid_done
	../../WPS/metgrid.exe
	grep -q COMPLETE metgrid.log && touch metgrid_done

geogrid:  geo_em.d01.nc geo_em.d02.nc
 geo_em.d01.nc geo_em.d02.nc:
	$(RM) $@
	../../WPS/geogrid.exe

ungrib: ungrib_done
ungrib_done: ../../grib/nam.t00z.awip3d12.tm00.grib2
	$(RM) Vtable FILE:*
	ln -sf ../../WPS/ungrib/Variable_Tables/Vtable.NAM Vtable
	../../WPS/link_grib.csh ../../grib/
	sed -i -e "/start_date/s/....-..-.._..:00:00/$(utc_yyyy)-$(utc_mon)-$(utc_today)_12:00:00/g" namelist.wps
	sed -i -e "/end_date/s/....-..-.._00:00:00/$(utc_yyyy)-$(utc_mon)-$(utc_tomorrow)_00:00:00/g" namelist.wps
	../../WPS/ungrib.exe
	grep -q COMPLETE ungrib.log && touch ungrib_done

clean:
	$(RM) ungrib_done FILE:* GRIBFILE.* geo_em.d0?.nc met_em.d0?.*:00:00.nc metgrid_done 
