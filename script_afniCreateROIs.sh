#!/usr/bin/tcsh


set infile = $1
set fname = `echo ${infile} | sed "s/\.csv//"`
set structure = $2

# 2020apr: with structure we define from where is script called: from WM or GM window

if ( ! -f TT_N27+tlrc.BRIK ) then
    set afnidir = `which afni | xargs dirname`
    3dcopy ${afnidir}/TT_N27+tlrc. ./
endif



3dcalc -overwrite  -a TT_N27+tlrc -expr "a*0" -prefix ${fname}_DTI_B1
3dcalc -overwrite  -a TT_N27+tlrc -expr "a*0" -prefix ${fname}_TBM_B1
3dcalc -overwrite  -a TT_N27+tlrc -expr "a*0" -prefix ${fname}_VBM_B1
3dcalc -overwrite  -a TT_N27+tlrc -expr "a*0" -prefix ${fname}_FS_B1
3dcalc -overwrite  -a TT_N27+tlrc -expr "a*0" -prefix ${fname}_Manual_B1


# If you use RAI, both x and y will be negated, that is, an input of [30 -4 10] 
# will place the coordinate at [-30 4 10].

# In addition, if you run the "- Talairach to" daemon tool, the coordinates for a 
# given structure are given in RAI regardless of your orientation (although you 
# are taken to the correct location even in LPI).

echo ${infile}

## space is not good delimiter

# create WM GM mask (could use some segmented volume... TO FIX)
## 2020marc20 threshold za belino naj bo 910, sivino med 430 in 910 Create outside the loop
3dcalc -a TT_N27+tlrc -expr "ispositive(a-150)" -prefix TT_N27_WMmask
3dcalc -a TT_N27+tlrc -b TT_N27_WMmask+tlrc -expr "ispositive(a-50)-b" -prefix TT_N27_GMmask


foreach j ("`cat ${infile}`")
	set i=`echo ${j} | sed "s/\ /_/g"`
	set author=`echo $i | awk -F "_" '{print $7}'`
	
	set X=`echo $i | awk -F "_" '{print $1}'`
	set Y=`echo $i | awk -F "_" '{print $2}'`
	set Z=`echo $i | awk -F "_" '{print $3}'`
	set V=`echo $i | awk -F "_" '{print $4}'`

	echo $author
	echo $Z

# if volume is too low we will not see anything
# lets define smallest Volume = 15
	if (${V} < 15) then
		set V=15
	endif

#   set X=`ccalc -form "%3d" -eval "$X*(-1)"`
#   set Y=`ccalc -form "%3d" -eval "$Y*(-1)"`
	
	## insert MNI to TLRC conversion
	set coord=`echo $i | awk -F "_" '{print $5}'`

	if (${coord} == "MNI") then
		set xyz=`whereami -calc_chain MNI TT_N27 -xform_xyz_quiet $X $Y $Z`
		set X=`echo ${xyz} | awk -F "[ ]" '{print $1}'`
		set Y=`echo ${xyz} | awk -F "[ ]" '{print $2}'`
		set Z=`echo ${xyz} | awk -F "[ ]" '{print $3}'`
	endif
	# check if this is true?!

	#set r=`ccalc -form "%4.1f" -eval "1.5*cbrt(3*$V/(4*pi))"`
	set r=`ccalc -form "%4.3f" -eval "cbrt(3*$V/(4*pi))"`
	# here we could iterativelly check if volume is large enough after masking WM
	# 1. check what is the focus of the analysis - GM or WM ... 
	## 2020apr OK change also GUI...
	# 1a second argument to script
	# 1b. !! add new radiobutton to GUI
	# 2. in this script create GM/WM mask (with threshold like 150 ... prever koliko si imel!) 
	## 2020marc20 threshold za belino naj bo 910, sivino med 430 in 910 Create outside the loop


        ## FIND A REFERENCE WHY X and Y must be negated !!!!!!
	#MATR VOLA... 
	# If you use RAI, both x and y will be negated, that is, an input of [30 -4 10] will place the coordinate at [-30 4 10].
	# In addition, if you run the "- Talairach to" daemon tool, the coordinates for a given structure are given in RAI 
	#  regardless of your orientation (although you are taken to the correct location even in LPI).

        set X=`ccalc -form "%3d" -eval "$X*(-1)"`
        set Y=`ccalc -form "%3d" -eval "$Y*(-1)"`

	echo "x: " $X "y: " $Y "z: " $Z "r: " $r

	3dcalc -overwrite -a TT_N27+tlrc                         \
            -expr "step(${r}*${r}-(x-${X})*(x-${X})-(y-${Y})*(y-${Y})-(z-${Z})*(z-${Z}))" \
            -prefix ball_${fname}_${i}_TT
# HM poglej ali nisem slučajno v bazah za clanek spreminjal predznakov... v zanki sem imel
# sphere_WMdown_2019_04_noFocusStudies.txt
# sphere_WMdown_2019_04_FocusStudies.txt
# sphere_WMup_2018_03.txt
# if ($author == "Hribar2014") then
#		set X=`ccalc -form "%3d" -eval "$X*(-1)"`
#		set Y=`ccalc -form "%3d" -eval "$Y*(-1)"`
#	endif


        #3dcopy ball_${fname}_${i}_TT+tlrc 1st_ball_${fname}_${i}_TT+tlrc
	set r1 = $r
######################################################################
# crazy loop 2020 april20
	#  check what structure / window has started that script
	if (${structure} == "WM") then
		set mask = "TT_N27_WMmask+tlrc"
	else
		set mask = "TT_N27_GMmask+tlrc"
	endif

	set nloops = 0
	set volDiffp = 20
	# iterating until volume flooding algorithm covers at least (100-7) percent of defined volume
	while ( ( ${volDiffp} >= 7 ) && ( ${nloops} <= 30 ) )
		# HM; that could mean that we prefer larger volumes 
		
		# mask ball_xx file with structure mask
		3dcalc -overwrite -a ball_${fname}_${i}_TT+tlrc -b ${mask} -expr "a*b" -prefix ballMasked_${fname}_${i}_TT # > /dev/null 2>&1
		# check number of voxels in ballMasked_ file
		# and compare number with volume
	
		set volAfter = `3dROIstats -nzvoxels -quiet -mask ${mask} ballMasked_${fname}_${i}_TT+tlrc | awk -F "\t" '{print $3}'` #> /dev/null 2>&1
#		echo "\n"
		# compare 
		set volDiff = `ccalc -form int -eval "${V}-${volAfter}"` #> /dev/null 2>&1
		echo "\n"
		echo "Expected Volume: " $V " \t Last computed Volume: " ${volAfter} " \t Volume difference: " ${volDiff} "\t iteration: " ${nloops}
		echo "\n"
		set rDiff = `ccalc -form "%4.3f" -eval "cbrt(3*${volDiff}/(4*pi)+${r}*${r}*${r})"` #> /dev/null 2>&1
#		echo "original r: " ${r1} " \t r before: " ${r} " \t r corrected: " ${rDiff}
#		echo "\n"
		
		3dcalc -overwrite -a TT_N27+tlrc                         \
            -expr "step(${rDiff}*${rDiff}-(x-${X})*(x-${X})-(y-${Y})*(y-${Y})-(z-${Z})*(z-${Z}))" \
            -prefix ball_${fname}_${i}_TT #> /dev/null 2>&1

		set r = ${rDiff}
		@ nloops ++
#		echo "\n"
#		echo "Number of Correcting r: " ${nloops}
#		echo "\n"
		set volDiffp = `ccalc -form int -eval "100*${volDiff}/${V}"`
	end

        echo "\n"
        echo "Volume corrected in iteration: " ${nloops} " \t original r: " ${r1} " \t r corrected: " ${rDiff} 
	echo "\n"
	echo "Expected Volume: " $V " \t Last computed Volume: " ${volAfter} " \t Volume difference: " ${volDiff} "\n"
        echo "\n"

	# create WARNING if Volume difference is too high!!!
	
	if (${volDiffp} >= 20) then
		echo "***************************************************"
		echo "WARNING... volume difference is too big."
		echo "probably your starting coordinates are wrong! \n"
		echo "***************************************************"
	endif



	rm ballMasked_${fname}_${i}_TT+tlrc.*


#########################################################################

	
    set metoda=`echo $i | awk -F "_" '{print $6}'`
    echo $metoda
    if (${metoda} == "DTI") then
		3dcalc  -overwrite -a ${fname}_DTI_B1+tlrc -b ball_${fname}_${i}_TT+tlrc -expr "a+b" -prefix ${fname}_DTI_B1
	endif

	if (${metoda} == "TBM") then
		3dcalc  -overwrite -a ${fname}_TBM_B1+tlrc -b ball_${fname}_${i}_TT+tlrc -expr "a+b" -prefix ${fname}_TBM_B1
	endif

	if (${metoda} == "VBM") then
		3dcalc  -overwrite -a ${fname}_VBM_B1+tlrc -b ball_${fname}_${i}_TT+tlrc -expr "a+b" -prefix ${fname}_VBM_B1
	endif

	if (${metoda} == "Freesurfer") then
		3dcalc  -overwrite -a ${fname}_FS_B1+tlrc -b ball_${fname}_${i}_TT+tlrc -expr "a+b" -prefix ${fname}_FS_B1
	endif

	if (${metoda} == "Manual") then
		3dcalc  -overwrite -a ${fname}_Manual_B1+tlrc -b ball_${fname}_${i}_TT+tlrc -expr "a+b" -prefix ${fname}_Manual_B1
	endif

	rm ball_${fname}_${i}_TT+tlrc*


end

3dcalc -a ${fname}_DTI_B1+tlrc -b ${fname}_TBM_B1+tlrc -c ${fname}_VBM_B1+tlrc -d ${fname}_FS_B1+tlrc -e ${fname}_Manual_B1+tlrc -expr "a+b+c+d+e" -prefix ${fname}_B1

echo "\n DONE \n"


