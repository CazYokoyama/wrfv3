# RUN WRF2GM
# Usage: ./test.sh [param ...]

# This script can set links for *.so depending on your architecture

# STUDY THE OPTIONS BELOW BEFORE USING!


# First determine machine type
# i386 and x86_64 supported
# Must have a CUDA capable nVidia card for x86_64 (currently)
mach=`uname -m`
echo $mach

# if [ $mach = "i686" ]; then
# 	rm -f ncl_jack_fortran.so
# 	ln -s ncl_jack_fortran-32bit.so ncl_jack_fortran.so
# 	rm -f wrf_user_fortran_util_0.so
# 	ln -s wrf_user_fortran_util_0-32bit.so wrf_user_fortran_util_0.so
# fi
# if [ $mach = "x86_64" ]; then
#	rm -f ncl_jack_fortran.so
#	ln -s libncl_jack.corei7-2012-03-22.so ncl_jack_fortran.so
#	ln -s libncl_jack.corei7A.so ncl_jack_fortran.so
#	ln -s ncl_jack_fortran-2012-03-17.so ncl_jack_fortran.so
#	rm -f wrf_user_fortran_util_0.so
#	ln -s wrf_user_fortran_util_0-64bit.so wrf_user_fortran_util_0.so
# fi


# THIS CODE REQUIRES NCL V6
# Version 5 (as supplied with RASP) *will not work*
# NCL V6 is usually  available in the distros
# NCARG_ROOT may well then be
export NCARG_ROOT=/usr

# You may need to specify the NCL_COMMAND, if not on your $PATH
NCL_COMMAND=$NCARG_ROOT/bin/ncl

# Specify Output Image Size
export GMIMAGESIZE=1600
# export GMIMAGESIZE=800

# Set the o/p format to "x11", "png" or "ncgm"
# Should be lower-case
# Not all versions of ncl support "png"
# Choose ONE only!
# export FMT="x11"
# export FMT="png"	# (Default)
# export FMT="ncgm"	# Not really supported (Who wants it?)

# You can specify PROJECTION to be Lambert, in which case o/p is same as RASP
# Useful as a test.
# export PROJECTION="Mercator" # Default
# export PROJECTION="Lambert"

# To test a single ENV_NCL_FILENAME, specify here
# export ENV_NCL_FILENAME="wrfout_d02_2012-03-19_14:00:00"
# export ENV_NCL_FILENAME="/home/rasp/WRF/WRFV2/RASP/UK2+1/SAFE.wrfout_d02_2012-06-10_12:00:00"
export ENV_NCL_FILENAME="/home/rasp/WRF/WRFV2/RASP/UK2+1/wrfout_d02_2012-07-20_12:00:00"
# export ENV_NCL_FILENAME="/home/rasp/WRF/WRFV2/RASP/UK4+1/wrfout_d02_2012-03-23_14:30:00"
# export ENV_NCL_FILENAME="/home/rasp/WRF/WRFV2/RASP/UK12/wrfout_d02_2012-03-31_07:30:00"

# Tests for Alan
# export ENV_NCL_FILENAME="/home/rasp/Downloads/sav_wrfout_d02_2012-03-28_23:00:00"
# export ENV_NCL_FILENAME="/home/rasp/Downloads/sav_wrfout_d02_2012-03-29_20:00:00"
# export ENV_NCL_FILENAME=/tmp/Alan/wrfout_d02_2012-04-16_02:00:00
# export ENV_NCL_FILENAME=/tmp/Alan/wrfout_d02_2012-04-15_20:00:00

# But don't change this - unless you want to explicitly specify it
export ENV_NCL_REGIONNAME=`echo $ENV_NCL_FILENAME | sed -e 's/.*RASP\///' | sed -e 's/\/.*//'`

# Build ENV_NCL_ID (as far as possible)
FILEDATE=`echo $ENV_NCL_FILENAME | cut -d _ -f 3`
FILETIME=`echo $ENV_NCL_FILENAME | cut -d _ -f 4`
localhh=`echo $FILETIME | cut -d : -f 1`
localmin=`echo $FILETIME | cut -d : -f 2`
localdow=`date -d $FILEDATE +%a`
localday=`date -d $FILEDATE +%-d`
localmon=`date -d $FILEDATE +%b`
localyyyy=`date -d $FILEDATE +%Y`
localtimeid=`date -d $FILEDATE +%Z`
filehh=`date -u -d $FILETIME +%H`
filemin=`date -u -d $FILETIME +%M`
file_creat_hr=`ls -l --time-style="+%H" $ENV_NCL_FILENAME | cut -d " " -f 6`
file_creat_mn=`ls -l --time-style="+%M" $ENV_NCL_FILENAME | cut -d " " -f 6`

# These cannot be filled in from a test script: In normal operation, rasp.pl supplies values
fcstperiodprt='??'
ztime='????'

# ENV_NCL_DATIME=`printf "Day= %d %d %d %s ValidLST= %d%02d %s ValidZ= %d%02d Fcst= %s Init= %d ",  $localyyyy,$localmon,$localday,$localdow, $localhh,$localmin,$localtimeid, $filehh,$filemin, $fcstperiod, $gribfcstperiod`
ENV_NCL_DATIME=`echo Day= $localyyyy $localmon $localday $localdow ValidLST= "$localhh""$localmin" $localtimeid ValidZ= "$filehh""$filemin" Fcst= $fcstperiodprt Init= $fcstperiodprt`

echo ENV_NCL_DATIME = $ENV_NCL_DATIME 
export ENV_NCL_DATIME



ENV_NCL_ID=`printf "Valid %02d%02d %s ~Z75~(%02d%02dZ)~Z~ %s %s %s %d ~Z75~[%shrFcst@%sz]~Z~" $localhh $localmin $localtimeid $filehh $filemin $localdow $localday $localmon $localyyyy $fcstperiodprt $ztime`

export ENV_NCL_ID

# If using ENV_NCL_FILENAME=... you may wish to set UNITS=celsius|metric|american
# UNITS="american" is default, to maintain compatibility with RASP
# export UNITS="celsius"
# Otherwise, Units are taken from rasp.region_data.ncl if a ENV_NCL_REGIONNAME is specified
# NB rasp.region_data is linked to ../NCL/rasp.ncl.region.data 

# To do all parameters for all files for a run, specify ENV_NCL_REGIONNAME
# All wrfout_d02* files in $BASEDIR/WRF/WRFV2/RASP/$ENV_NCL_REGIONNAME are processed

# PARAMETERS
# NB: Soundings *MUST* be last
# This is a bug, which I have not been able to fix - even with the help of ncl-talk!
# RASP puts Soundings at the end, so all should be well (?)

# This is a fairly full set (uncomment each line)
export ENV_NCL_PARAMS="mslpress:sfcwind0:sfcwind:sfcwind2:blwind:\
bltopwind:dbl:experimental1:sfctemp:zwblmaxmin:blicw:hbl:hwcrit:\
dwcrit: wstar:bsratio:sfcshf:zblcl:zblcldif:\
zblclmask:blcwbase:press1000:press950:press850:press700:press500:\
bltopvariab:wblmaxmin:zwblmaxmin:blwindshear:sfctemp:sfcdewpt:cape:\
rain1:wrf=HGT:wstar_bsratio:bsratio_bsratio:\
blcloudpct:sfcsunpct:zsfclcl:zsfclcldif:zsfclclmask:\
hglider:stars:\
sounding1:sounding2:sounding3:sounding4:sounding5:sounding6:sounding7:\
sounding8:sounding9:sounding10:sounding11:sounding12:sounding13:sounding14:sounding15"


# Overide Params with cmd-line args
# Can be space-separated OR ":" separated
if [ $# -gt 0 ]
then
	ENV_NCL_PARAMS=`echo $* | sed -e 's/ /:/g'`
	export ENV_NCL_PARAMS
fi

# To use the NCL supplied wrf_user_getvar() select NCL below.
# However, *note carefully* DrJack's observations about "mass" and "grid" points
# and "staggered" and "unstaggered" grids, to be found at 
# http://www.drjack.info/twiki/bin/view/RASPop/AdvancedPlotting

# export GETVAR=DRJACK # Default
# export GETVAR=NCL

# For use with RASP, set ENV_NCL_OUTDIR as below (rasp.pl sets this)
# export ENV_NCL_OUTDIR=$BASEDIR/RASP/HTML/$ENV_NCL_REGIONNAME/GM

# To test for differences between NCL & DrJack's wrf_user_getvar()
# you may wish to set ENV_NCL_OUTDIR as below

# if [ $GETVAR == "DRJACK" ]
# then
# 	export ENV_NCL_OUTDIR=./DrJack
# else
# 	export ENV_NCL_OUTDIR=./NCL
# fi

# Ensure Output Directories exist
if [ ! -d $ENV_NCL_OUTDIR ]
then
	mkdir -p $ENV_NCL_OUTDIR
fi

# Finally!!
$NCL_COMMAND -n -p wrf2gm.ncl

exit 
