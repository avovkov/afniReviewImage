#!/usr/bin/tcsh

#afni -com 'SAVE_JPEG axialimage zork1; QUIT' -layout .afni_ROIs_Layout -npb 4 -niml-yesplugouts -dset MNI152_T1_1mm_LPI+tlrc GMtest_DTITBMVBMFSManM_B1+tlrc
set mask=$1
echo ${mask}



suma -spec SUMA_COMBO_2.spec -sv TT_N27_SurfVol.nii






#######################################################################
afni -layout .afni_ROIs_Layout -npb 4 -niml -yesplugouts

sleep 4

# opa _B1B2_WM+tlr ce gledamo GM ne uporabmo WM... itak pa bomo tam s SUMO pogledal...

plugout_drive -npb 4 \
               -com "SWITCH_UNDERLAY TT_N27+tlrc"  \
               -com "SWITCH_OVERLAY ${mask}_B1B2_WM+tlrc" \
               -com "SAVE_JPEG axialimage ${mask}" \
               -quit

# howto Quit afni --- ?
