#!/usr/bin/tcsh

#afni -com 'SAVE_JPEG axialimage zork1; QUIT' -layout .afni_ROIs_Layout -npb 4 -niml-yesplugouts -dset TT_N27+tlrc GMtest_DTITBMVBMFSManM_B1+tlrc
set mask=$1
echo ${mask}
afni -layout .afni_ROIs_Layout -npb 4 -niml -yesplugouts

sleep 4

plugout_drive -npb 4 \
               -com "SWITCH_UNDERLAY TT_N27+tlrc"  \
               -com "SWITCH_OVERLAY ${mask}_B1+tlrc" \
               -com "SAVE_JPEG axialimage ${mask}" \
               -quit

# howto Quit afni --- ?
