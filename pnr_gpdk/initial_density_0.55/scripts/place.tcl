#set restore_db_file_check 0
#restoreDesign DESIGN/fp2.inn.dat picosoc
setMultiCpuUsage -localCpu 8


timeDesign -prePlace > report/place/preplacetiming.rpt
setDesignMode -topRoutingLayer 11


specifyCellPad SDF* -left 1 -right 1
specifyCellPad DFF* -left 1 -right 1


setPlaceMode -place_global_uniform_density true
setPlaceMode -place_global_cong_effort high
setPlaceMode -place_global_max_density 0.40 
#setPlaceMode -place_global_cong_effort high
setDesignMode -flowEffort extreme
colorizePowerMesh
place_design
setTieHiLoMode -maxFanout 10 -maxDistance 20 -cell "TIEHI TIELO" -prefix TIEHILO
addTieHiLo

checkDesign -all > report/place/checkDesign.rpt
mkdir -p report/place 
report_timing -path_type full_clock -from [all_inputs] -to [all_registers ] -max_paths 999999 > report/place/intoreg1.rpt
 report_timing -path_type full_clock -from [all_registers ] -to [all_registers ] -max_paths 999999 > report/place/regtoreg1.rpt
 report_timing -path_type full_clock -from [all_registers ] -to [all_outputs ]  -max_paths 999999 > report/place/regtout1.rpt

reportFootPrint -dontTouchNUse -outfile report/place/dontusecell

setOptMode -opt_setup_target_slack 0.1
setOptMode -opt_hold_target_slack 0.05

optDesign -preCTS


checkDesign -all > report/place/checkDesign_opt.rpt
 report_timing -path_type full_clock -from [all_inputs] -to [all_registers ] -max_paths 999999 > report/place/intoreg2.rpt
 report_timing -path_type full_clock -from [all_registers ] -to [all_registers ] -max_paths 999999 > report/place/regtoreg2.rpt 
 report_timing -path_type full_clock -from [all_registers ] -to [all_output]  -max_paths 999999 > report/place/regtout2.rpt
saveDesign DESIGN/place.inn
#exit
         
