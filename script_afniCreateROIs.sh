#!/usr/bin/tcsh


set infile = $1
set fname = `echo ${infile} | sed "s/\.txt//"`


if ( ! -f MNI152_T1_1mm_LPI+tlrc.BRIK ) then
    set afnidir = `which afni | xargs dirname`
    3dcopy ${afnidir}/MNI152_2009_template.nii.gz ./MNI152_T1_1mm_LPI
    #3drefit -orient LPI -view +tlrc MNI152_T1_1mm_LPI+orig
endif

3dcalc -overwrite  -a MNI152_T1_1mm_LPI+tlrc -expr "a*0" -prefix ${fname}_DTI_B1
3dcalc -overwrite  -a MNI152_T1_1mm_LPI+tlrc -expr "a*0" -prefix ${fname}_TBM_B1
3dcalc -overwrite  -a MNI152_T1_1mm_LPI+tlrc -expr "a*0" -prefix ${fname}_VBM_B1
3dcalc -overwrite  -a MNI152_T1_1mm_LPI+tlrc -expr "a*0" -prefix ${fname}_Freesurfer_B1
3dcalc -overwrite  -a MNI152_T1_1mm_LPI+tlrc -expr "a*0" -prefix ${fname}_Manual_B1


# If you use RAI, both x and y will be negated, that is, an input of [30 -4 10] 
# will place the coordinate at [-30 4 10].

# In addition, if you run the "- Talairach to" daemon tool, the coordinates for a 
# given structure are given in RAI regardless of your orientation (although you 
# are taken to the correct location even in LPI).

echo ${infile}

## space is not good delimiter

foreach j ("`cat ${infile}`")
	set i=`echo ${j} | sed "s/\ /_/g"`
	set author=`echo $i | awk -F "_" '{print $7}'`
	
	set X=`echo $i | awk -F "_" '{print $1}'`
	set Y=`echo $i | awk -F "_" '{print $2}'`
	set Z=`echo $i | awk -F "_" '{print $3}'`
	set V=`echo $i | awk -F "_" '{print $4}'`

	echo $author
	echo $Z

   set X=`ccalc -form "%3d" -eval "$X*(-1)"`
   set Y=`ccalc -form "%3d" -eval "$Y*(-1)"`
	
	## insert TLRC to MNI conversion
	set coord=`echo $i | awk -F "_" '{print $5}'`

	if (${coord} == "TLRC") then
		set xyz=`whereami -calc_chain TT_N27 MNI -xform_xyz_quiet $X $Y $Z`
		set X=`echo ${xyz} | awk -F "[ ]" '{print $1}'`
		set Y=`echo ${xyz} | awk -F "[ ]" '{print $2}'`
		set Z=`echo ${xyz} | awk -F "[ ]" '{print $3}'`
	endif
	# check if this is true?!

	set r=`ccalc -form "%4.1f" -eval "1.5*cbrt(3*$V/(4*pi))"`
	# here we could iterativelly check if volume is large enough after masking WM
	# 1. check what is the focus of the analysis - GM or WM
	# 1a second argument to script
	# 1b. !! add new radiobutton to GUI
	# 2. in this script create GM/WM mask (with threshold like 150 ... prever koliko si imel!)

	echo "x: " $X "y: " $Y "z: " $Z "r: " $r

	3dcalc -overwrite -a MNI152_T1_1mm_LPI+tlrc                         \
            -expr "step(${r}*${r}-(x-${X})*(x-${X})-(y-${Y})*(y-${Y})-(z-${Z})*(z-${Z}))" \
            -prefix ball_${fname}_${i}_MNI

    set metoda=`echo $i | awk -F "_" '{print $6}'`
    echo $metoda
    if (${metoda} == "DTI") then
		3dcalc  -overwrite -a ${fname}_DTI_B1+tlrc -b ball_${fname}_${i}_MNI+tlrc -expr "a+b" -prefix ${fname}_DTI_B1
	endif

	if (${metoda} == "TBM") then
		3dcalc  -overwrite -a ${fname}_TBM_B1+tlrc -b ball_${fname}_${i}_MNI+tlrc -expr "a+b" -prefix ${fname}_TBM_B1
	endif

	if (${metoda} == "VBM") then
		3dcalc  -overwrite -a ${fname}_VBM_B1+tlrc -b ball_${fname}_${i}_MNI+tlrc -expr "a+b" -prefix ${fname}_VBM_B1
	endif

	if (${metoda} == "Freesurfer") then
		3dcalc  -overwrite -a ${fname}_Freesurfer_B1+tlrc -b ball_${fname}_${i}_MNI+tlrc -expr "a+b" -prefix ${fname}_Freesurfer_B1
	endif

	if (${metoda} == "Manual") then
		3dcalc  -overwrite -a ${fname}_Manual_B1+tlrc -b ball_${fname}_${i}_MNI+tlrc -expr "a+b" -prefix ${fname}_Manual_B1
	endif

	rm ball_${fname}_${i}_MNI+tlrc*


end

3dcalc -a ${fname}_DTI_B1+tlrc -b ${fname}_TBM_B1+tlrc -c ${fname}_VBM_B1+tlrc -d ${fname}_Freesurfer_B1+tlrc -e ${fname}_Manual_B1+tlrc -expr "a+b+c+d+e" -prefix ${fname}_B1

echo "\n DONE \n"


