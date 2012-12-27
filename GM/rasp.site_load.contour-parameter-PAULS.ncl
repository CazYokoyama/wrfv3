;;; TO ALTER CONTOUR PARAMETER PLOT SECTION

;;; example of altering wstar parameter contour interval/coloring
;;; (for more details see "Change plot formatting" section at http://www.drjack.info/twiki/bin/view/RASPop/ProgramUserChanges
;;example:  if( plot_param .eq. "wstar" ) then
  ;;example=fixed_colors:  opts_bparam@ContourParameters = (/ 100., 800., 100. /)
  ;;example=autoset_colors:  opts_bparam@ContourParameters = (/ 0., 0., 0. /)
  ;;example=autoset_colors:  delete( opts_bparam@ContourParameters )
;;example:  end if

;;;; PAULS ;;;;

if( plot_param .eq. "wrf_RAINNC" ) then
  opts_bparam@ContourParameters = (/ 1., 9., 1. /)
end if

; If plotting takes a LOOONGG time, try this
if( Region .eq. "UK2+1" ) then
  opts_plot@cnFillMode = "RasterFill"
  ; opts_plot@cnRasterSmoothingOn = True ; Can use this to smooth edges a bit - Not much difference!
else
  opts_plot@cnFillMode = "AreaFill"
end if

if( plot_param .eq. "rain1" ) then
  opts_bparam@ContourParameters = (/ 0.1, 4.9, 0.1 /)
end if

; TJ's Specials
; if( ( plot_param .eq. "hwcrit" ) .or. ( plot_param .eq. "hglider" ) .or. ( plot_param .eq. "hbl" )  .or.  ( plot_param .eq. "dbl" ) )   then 
;    setvalues wks
;     "wkColorMap": "whgryeorre13"
;     "wkForegroundColor" : (/.2,.2,1./)
;     "wkBackgroundColor" : (/.87, .96, 1./)
;    end setvalues
;     opts_bparam@ContourParameters = (/ 500., 11000., 1000. /)
;  end if

if( plot_param .eq. "wstar_bsratio" ) then
  opts_bparam@ContourParameters = (/ 175., 575., 25. /)
end if

if( plot_param .eq. "wstar" ) then
  opts_bparam@ContourParameters = (/ 175., 575., 25. /)
end if

if( plot_param .eq. "sfcsunpct" ) then
  ldatafmt = 2
  opts_bparam@ContourParameters = (/ 10., 90., 10. /)
end if

if( plot_param .eq. "blcloudpct" ) then
  opts_bparam@ContourParameters = (/ 10., 90., 10. /)
end if

if( plot_param .eq. "experimental2" ) then
  opts_bparam@ContourParameters = (/ 5., 95., 5. /)
end if

if( plot_param .eq. "stars" .or. plot_param .eq. "starshg") then
 	ldatafmt = 2
end if

 
; CAN'T HAVE THIS WITH GM
; It's already built in
;;;        RAIN PLOT --- Courtesy Hendrik :-) --- Added 3/1/2009

;  if( name_max .ge. 4 .and. name_chars(0:3) .eq. "rain" ) then
;    ;; Extract the accumulation time from the parameter name
;    acctime = stringtointeger( chartostring( name_chars(4:name_max) ) )

;    ;; Get filename for the previous forecast. Needed to subtract earlier rain.
;    filename_chars = stringtochar( ENV_NCL_FILENAME )
;    len_filename = dimsizes(filename_chars)-2
;    ; date of current file
;    sdate = string_target_replace(chartostring( filename_chars(len_filename-18:len_filename-6)), "_", "-" )
;    stime = filename_chars(len_filename-4:len_filename)
;    date  = stringtointeger(split_string_into_array( sdate,"-" ))
;    ; date of previous file
;    prevdate  = jul2greg( greg2jul(date(0),date(1),date(2),date(3)) - acctime/24. + 0.00001 )
;    sprevdate = sprinti("%d-",prevdate(0)) + sprinti("%02d-",prevdate(1)) + sprinti("%02d_",prevdate(2)) + sprinti("%02d:", prevdate(3)) + stime 
;    prevfilename = chartostring( filename_chars(0:len_filename-19)) + sprevdate
;    print ( "prevfilename = "+prevfilename )

;    delete(filename_chars)
;    delete(len_filename)
;    delete(date)
;    delete(sdate)
;    delete(prevdate)
;    delete(sprevdate)

;    ;; If the previous file exists -> load it, subtract earlier rain, plot it.
;    if (isfilepresent(prevfilename)) then
;      prevfile = addfile( prevfilename+".nc", "r" )

;      bparam = new( (/jsize,isize/), float )
;      bparam_filename = string_target_replace( ENV_NCL_FILENAME, "dummy","rain" )

;      rainc  = a->RAINC
;      rainnc = a->RAINNC
;      prevrainc  = prevfile->RAINC
;      prevrainnc = prevfile->RAINNC

;      ; Use NCL operator > to make sure all values >=0.0
;      rainc  = rainc > 0.0
;      rainnc = rainnc > 0.0
;      prevrainc  = prevrainc > 0.0
;      prevrainnc = prevrainnc > 0.0

;		 ;PAULS - 2 places of decimals for rain
;		 ldatafmt = 2

;      rainTot = (/ rainc + rainnc - prevrainc - prevrainnc /)
;      bparam = rainTot
;      opts_bparam = True
;      opts_bparam@UnitLabel = "[mm]"
;      opts_bparam@MainTitle = acctime+" hr Accumulated Rain"
;      qparaminfo = ""

;      delete(prevfile)
;      delete(rainc)
;      delete(rainnc)
;      delete(prevrainc)
;      delete(prevrainnc)
;    else
;      print ("Can't open "+prevfilename+" needed for rain plot.")
;    end if
;    delete(acctime)
;    delete(prevfilename)

;  end if        ; end of rain plot section

;;; =======================================================================
