#!/usr/bin/tcsh

#afni -com 'SAVE_JPEG axialimage zork1; QUIT' -layout .afni_ROIs_Layout -npb 4 -niml-yesplugouts -dset MNI152_T1_1mm_LPI+tlrc GMtest_DTITBMVBMFSManM_B1+tlrc
set mask=$1
echo ${mask}



suma -spec SUMA_COMBO_2.spec -sv TT_N27_SurfVol.nii -niml &

afni -niml -yesplugouts 

#-npb 4


#######################################################################


sleep 4

# opa _B1B2_WM+tlr ce gledamo GM ne uporabmo WM... itak pa bomo tam s SUMO pogledal...

#-npb 4 \
echo ${mask}"_B1B2_GM+tlrc"

plugout_drive -com "SWITCH_UNDERLAY TT_N27+tlrc"  \
               -com "SWITCH_OVERLAY ${mask}_B1B2_TTn27+tlrc" \
               -quit

# howto Quit afni --- ?

#plugout_drive -com "SWITCH_UNDERLAY TT_N27+tlrc" -com "SWITCH_OVERLAY GM_Regions_test3_VBM_B2+tlrc" -quit

sleep 2

DriveSuma   -com viewer_cont  -viewer_size 800 800 
DriveSuma   -com viewer_cont  -key 'alt+t'
sleep 2
DriveSuma   -com viewer_cont  -key ','
sleep 2
DriveSuma -com viewer_cont -key ctrl+right
DriveSuma -com viewer_cont -key:r20:s0.3 right


# Check examples https://afni.nimh.nih.gov/pub/dist/doc/program_help/DriveSuma.html

# DriveSuma -com  viewer_cont -key R -key ctrl+right
# DriveSuma -com  viewer_cont -key:r3:s0.3 up  \
#                       -key:r2:p left -key:r5:d right \
#                       -key:r3 z   -key:r5 left -key F6
#       DriveSuma -com  viewer_cont -key m -key down \
#                 -com  sleep 2s -com viewer_cont -key m \
#                       -key:r4 Z   -key ctrl+right
#       DriveSuma -com  viewer_cont -key m -key right \
#                 -com  pause press enter to stop this misery \
#                 -com  viewer_cont -key m 






