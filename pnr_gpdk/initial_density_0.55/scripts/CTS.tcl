#set restore_db_file_check 0
#restoreDesign DESIGN/place.inn.dat picosoc
setDesignMode -topRoutingLayer 11
setMultiCpuUsage -localCpu 8
defOut -floorplan -placement   postplace.def
saveNetlist postplace.v


set timing_enable_simultaneous_setup_hold_mode false

set_interactive_constraint_modes [all_constraint_modes ]
set_propagated_clock [all_clocks ]
set_global report_timing_format {instance arc cell net load delay arrival required }

deleteAllCellPad

timeDesign -preCTS -outDir report/prects/preCTSOptTiming
setDesignMode -flowEffort extreme

#set_ccopt_property route_type -target_max_trans
#set_ccopt_property target_skew
ccopt_design -CTS
mkdir -p report/prects

#setOptMode -opt_setup_target_slack 0.1
##setOptMode -opt_hold_target_slack 0.05


checkDesign -all > report/prects/checkDesign_prects.rpt

report_timing -path_type full_clock -from [all_inputs] -to [all_registers ] -max_paths 999999 > report/prects/intoreg3.rpt
report_timing -path_type full_clock -from [all_registers ] -to [all_registers ] -max_paths 999999 > report/prects/regtoreg3.rpt
report_timing -path_type full_clock -from [all_registers ] -to [all_outputs ] -max_paths 999999 > report/prects/regtout3.pt
set timing_enable_simultaneous_setup_hold_mode true
report_timing -path_type full_clock -check_type hold -from  [all_inputs] -to [all_registers ] -max_paths 999999 > report/prects/intoreg4.rpt
report_timing -path_type full_clock -check_type hold -from  [all_registers] -to [all_registers ] -max_paths 999999 > report/prects/regtoreg4.rpt
report_timing -path_type full_clock -check_type hold -from  [all_registers] -to [all_outputs ] -max_paths 999999 > report/prects/regtout4.rpt
set timing_enable_simultaneous_setup_hold_mode false
setDesignMode -flowEffort extreme
#setOptMode -opt_setup_target_slack 0.1 -opt_drv_margin 0.10
optDesign -postCTS
mkdir -p report/postcts

timeDesign -postCTS -outDir report/postcts/ctsTimingReports
checkDesign -all > report/postcts/checkDesign_postcts.rpt
report_timing -path_type full_clock -from [all_inputs] -to [all_registers ] -max_paths 999999 > report/postcts/intoreg3opt.rpt
report_timing -path_type full_clock -from [all_registers ] -to [all_registers ] -max_paths 999999 > report/postcts/regtoreg3opt.rpt
report_timing -path_type full_clock -from [all_registers ] -to [all_outputs ] -max_paths 999999 > report/postcts/regtout3opt.rpt

set timing_enable_simultaneous_setup_hold_mode true

report_timing -path_type full_clock -check_type hold -from  [all_inputs] -to [all_registers ]  -max_paths 999999 > report/postcts/intoreg4opth.rpt
report_timing -path_type full_clock -check_type hold -from  [all_registers] -to [all_registers ]  -max_paths 999999 > report/postcts/regtoreg4opth.rpt
report_timing -path_type full_clock -check_type hold -from  [all_registers] -to [all_outputs ]  -max_paths 999999 > report/postcts/regtout4opth.rpt

saveDesign DESIGN/cts.inn
#exit
 

