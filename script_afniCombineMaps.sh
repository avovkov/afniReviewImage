#!/usr/bin/tcsh


set fname=$1
echo ${fname}
set pref=`echo ${fname} | awk -F "_" '{print $1}'`
set suf=`echo ${fname} | awk -F "_" '{print $2}'`

adwarp -apar TT_N27+tlrc -dpar ${pref}_ROIs_${suf}_B1+tlrc -prefix TTn27_${pref}_${suf}_B1 -force

3dcalc -a TTn27_${pref}_${suf}_B1+tlrc -b ${pref}_Regions_${suf}_B2+tlrc -expr "a+b" -prefix ${pref}_${suf}_B1B2_TTn27

3dcalc -a TT_N27+tlrc -b ${pref}_${suf}_B1B2_TTn27+tlrc -expr "ispositive(a-150)*b" -prefix ${pref}_${suf}_B1B2_TTn27_WM

echo "\n DONE \n"
