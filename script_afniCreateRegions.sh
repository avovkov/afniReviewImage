#!/usr/bin/tcsh


set infile = $1
set fname = `echo ${infile} | sed "s/\.txt//"`

##################################################################################
# change coordinates to MNI

# whereami -calc_chain TT_N27 MNI -xform_xyz_quiet


##################################################################################
# Before you run this command you'll most likely need the following setup in your 
# .afnirc

## AFNI_ANALYZE_ORIENT = LPI
## AFNI_ANALYZE_ORIGINATOR = YES

# then run:    CHANGE

if ( ! -f TT_N27+tlrc.HEAD ) then
    set afnidir = `which afni | xargs dirname`
    3dcopy ${afnidir}/TT_N27+tlrc ./
endif

if ( ! -f JHU-WhiteMatter-labels-1mm+tlrc.HEAD ) then
    set afnidir = `which afni | xargs dirname`
    3dcopy ${afnidir}/JHU-WhiteMatter-labels-1mm+tlrc ./
endif



3dcalc -overwrite  -a TT_N27+tlrc -expr "a*0" -prefix ${fname}_VBM_B2
3dcalc -overwrite  -a TT_N27+tlrc -expr "a*0" -prefix ${fname}_Manual_B2
3dcalc -overwrite  -a TT_N27+tlrc -expr "a*0" -prefix ${fname}_TBM_B2
3dcalc -overwrite  -a TT_N27+tlrc -expr "a*0" -prefix ${fname}_DTI_B2
3dcalc -overwrite  -a TT_N27+tlrc -expr "a*0" -prefix ${fname}_Freesurfer_B2



foreach i ("`cat ${infile}`")
	set author=`echo $i | awk -F " " '{print $4}'`
	
	set X=`echo $i | awk -F " " '{print $1}'`
	set atlas=`echo $i | awk -F " " '{print $2}'`
	set metoda=`echo $i | awk -F " " '{print $3}'`

	echo $X " "  $atlas " " $metoda

	# we might want to to something special for each metod
	if (${metoda} == "VBM") then
		echo "WORKING in VBM"
		if (${atlas} == "CA_N27_ML") then
			echo "WE HAVE CA_N27 atlas"
			3dcalc  -overwrite -a ${fname}_${metoda}_B2+tlrc -b "CA_N27_ML::$X" -expr "a+b" -prefix ${fname}_${metoda}_B2
		endif
		if (${atlas} == "DD_Desai_PM") then
			echo "WE HAVE DD_Desai atlas"
			3dcalc -a "DD_Desai_PM::$X" -expr "ispositive(a-150)" -prefix _regionTemp
			3dcalc  -overwrite -a ${fname}_${metoda}_B2+tlrc -b _regionTemp+tlrc -expr "a+b" -prefix ${fname}_${metoda}_B2
			rm _regionTemp+tlrc*
		endif
		if (${atlas} == "JHU-WhiteMatter-labels") then
			echo "WE HAVE JHU white matter atlas"
			set Y=`echo $X | awk -F "_" '{print $1}'`
			3dcalc  -overwrite -a ${fname}_${metoda}_B2+tlrc -b "JHU-WhiteMatter-labels-1mm+tlrc" -expr "a+iszero(b-$Y)" -prefix ${fname}_${metoda}_B2
		endif
	endif

	if (${metoda} == "TBM") then
		echo "WORKING in TBM"
		if (${atlas} == "CA_N27_ML") then
			echo "WE HAVE CA_N27 atlas"
			3dcalc  -overwrite -a ${fname}_${metoda}_B2+tlrc -b "CA_N27_ML::$X" -expr "a+b" -prefix ${fname}_${metoda}_B2
		endif
		if (${atlas} == "DD_Desai_PM") then
			echo "WE HAVE DD_Desai atlas"
			3dcalc -a "DD_Desai_PM::$X" -expr "ispositive(a-150)" -prefix _regionTemp
			3dcalc  -overwrite -a ${fname}_${metoda}_B2+tlrc -b _regionTemp+tlrc -expr "a+b" -prefix ${fname}_${metoda}_B2
			rm _regionTemp+tlrc*
		endif
		if (${atlas} == "JHU-WhiteMatter-labels") then
			echo "WE HAVE JHU white matter atlas"
			set Y=`echo $X | awk -F "_" '{print $1}'`
			3dcalc  -overwrite -a ${fname}_${metoda}_B2+tlrc -b "JHU-WhiteMatter-labels-1mm+tlrc" -expr "a+iszero(b-$Y)" -prefix ${fname}_${metoda}_B2
		endif
	endif


	if (${metoda} == "Manual") then
		echo "WORKING in TBM"
		if (${atlas} == "CA_N27_ML") then
			echo "WE HAVE CA_N27 atlas"
			3dcalc  -overwrite -a ${fname}_${metoda}_B2+tlrc -b "CA_N27_ML::$X" -expr "a+b" -prefix ${fname}_${metoda}_B2
		endif
		if (${atlas} == "DD_Desai_PM") then
			echo "WE HAVE DD_Desai atlas"
			3dcalc -a "DD_Desai_PM::$X" -expr "ispositive(a-150)" -prefix _regionTemp
			3dcalc  -overwrite -a ${fname}_${metoda}_B2+tlrc -b _regionTemp+tlrc -expr "a+b" -prefix ${fname}_${metoda}_B2
			rm _regionTemp+tlrc*
		endif
		if (${atlas} == "JHU-WhiteMatter-labels") then
			echo "WE HAVE JHU white matter atlas"
			set Y=`echo $X | awk -F "_" '{print $1}'`
			3dcalc  -overwrite -a ${fname}_${metoda}_B2+tlrc -b "JHU-WhiteMatter-labels-1mm+tlrc" -expr "a+iszero(b-$Y)" -prefix ${fname}_${metoda}_B2
		endif
	endif

	if (${metoda} == "DTI") then
		echo "WORKING in TBM"
		if (${atlas} == "CA_N27_ML") then
			echo "WE HAVE CA_N27 atlas"
			3dcalc  -overwrite -a ${fname}_${metoda}_B2+tlrc -b "CA_N27_ML::$X" -expr "a+b" -prefix ${fname}_${metoda}_B2
		endif
		if (${atlas} == "DD_Desai_PM") then
			echo "WE HAVE DD_Desai atlas"
			3dcalc -a "DD_Desai_PM::$X" -expr "ispositive(a-150)" -prefix _regionTemp
			3dcalc  -overwrite -a ${fname}_${metoda}_B2+tlrc -b _regionTemp+tlrc -expr "a+b" -prefix ${fname}_${metoda}_B2
			rm _regionTemp+tlrc*
		endif
		if (${atlas} == "JHU-WhiteMatter-labels") then
			echo "WE HAVE JHU white matter atlas"
			set Y=`echo $X | awk -F "_" '{print $1}'`
			3dcalc  -overwrite -a ${fname}_${metoda}_B2+tlrc -b "JHU-WhiteMatter-labels-1mm+tlrc" -expr "a+iszero(b-$Y)" -prefix ${fname}_${metoda}_B2
		endif
	endif

	if (${metoda} == "Freesurfer") then
		echo "WORKING in TBM"
		if (${atlas} == "CA_N27_ML") then
			echo "WE HAVE CA_N27 atlas"
			3dcalc  -overwrite -a ${fname}_${metoda}_B2+tlrc -b "CA_N27_ML::$X" -expr "a+b" -prefix ${fname}_${metoda}_B2
		endif
		if (${atlas} == "DD_Desai_PM") then
			echo "WE HAVE DD_Desai atlas"
			3dcalc -a "DD_Desai_PM::$X" -expr "ispositive(a-150)" -prefix _regionTemp
			3dcalc  -overwrite -a ${fname}_${metoda}_B2+tlrc -b _regionTemp+tlrc -expr "a+b" -prefix ${fname}_${metoda}_B2
			rm _regionTemp+tlrc*
		endif
		if (${atlas} == "JHU-WhiteMatter-labels") then
			echo "WE HAVE JHU white matter atlas"
			set Y=`echo $X | awk -F "_" '{print $1}'`
			3dcalc  -overwrite -a ${fname}_${metoda}_B2+tlrc -b "JHU-WhiteMatter-labels-1mm+tlrc" -expr "a+iszero(b-$Y)" -prefix ${fname}_${metoda}_B2
		endif
	endif


end





3dcalc -a ${fname}_VBM_B2+tlrc -b ${fname}_TBM_B2+tlrc -c ${fname}_Manual_B2+tlrc -d ${fname}_DTI_B2+tlrc -e ${fname}_Freesurfer_B2+tlrc -expr "a+b+c+d+e" -prefix ${fname}_B2


echo "\n DONE \n"


