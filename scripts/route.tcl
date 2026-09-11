#set restore_db_file_check 0
#restoreDesign DESIGN/cts.inn.dat picosoc
setMultiCpuUsage -localCpu 8
setAnalysisMode -analysisType onChipVariation

setDesignMode -topRoutingLayer 5
set_interactive_constraint_modes [all_constraint_modes ]
set_propagated_clock [all_clocks ]
set_global report_timing_format {instance arc cell net load delay arrival required }
set timing_enable_simultaneous_setup_hold_mode false
#antenna fix
setNanoRouteMode -route_antenna_cell_name ANTENA
setNanoRouteMode -route_antenna_diode_insertion true
#setDesignMode -expressRoute true

setDesignMode -flowEffort extreme
routeDesign
#set step route
checkDesign -all > report/route/checkDesign_route.rpt
report_timing -path_type full_clock -from [all_inputs] -to [all_registers ] -max_paths 999999 > report/route/intoreg5opth.rpt
report_timing -path_type full_clock -from [all_registers ] -to [all_registers ] -max_paths 999999 > report/route/regtoregsetup.rpt
report_timing -path_type full_clock -from [all_registers ] -to [all_outputs ] -max_paths 999999 > report/route/regtout5opth.rpt
set timing_enable_simultaneous_setup_hold_mode true
report_timing -path_type full_clock -check_type hold -from  [all_inputs] -to [all_registers ] -max_paths 999999 > report/route/intoreg5opth.rpt
report_timing -path_type full_clock -check_type hold -from  [all_registers] -to [all_registers ] -max_paths 999999 > report/route/regtoreghold.rpt
report_timing -path_type full_clock -check_type hold -from  [all_registers] -to [all_outputs ] -max_paths 999999 > report/route/regtout5opth.rpt
set timing_enable_simultaneous_setup_hold_mode false
setAnalysisMode -analysisType onChipVariation
setOptMode -opt_setup_target_slack 0.1
setOptMode -opt_hold_target_slack 0.05

optDesign -postRoute 

checkDesign -all > report/route/checkDesign_opt_route.rpt
report_timing -path_type full_clock -from [all_inputs] -to [all_registers ] -max_paths 999999 > report/route/intoreg6opth.rpt
report_timing -path_type full_clock -from [all_registers ] -to [all_registers ] -max_paths 999999 > report/route/regtoregsetopt.rpt
report_timing -path_type full_clock -from [all_registers ] -to [all_outputs ] -max_paths 999999 > report/route/regtout6opth.rpt
report_timing -machine_readable -path_type full_clock -from [all_registers ] -to [all_registers ] -max_paths 999999 > report/route/machine_setopt.rpt


set timing_enable_simultaneous_setup_hold_mode true
report_timing -path_type full_clock -check_type hold -from  [all_inputs] -to [all_registers ]  -max_paths 999999 > report/route/intoreg7opth.rpt
report_timing -path_type full_clock -check_type hold -from  [all_registers] -to [all_registers ] -max_paths 999999 > report/route/regtoregholdopt.rpt
report_timing -path_type full_clock -check_type hold -from  [all_registers] -to [all_outputs ] -max_paths 999999 > report/route/regtout7opth.rpt
report_timing -machine_readable -path_type full_clock -check_type hold -from  [all_registers] -to [all_registers ] -max_paths 999999 > report/route/machine_opthold.rpt


set timing_enable_simultaneous_setup_hold_mode false

globalNetConnect VDD -instanceBasename * -pin VDD -verbose
globalNetConnect VSS -instanceBasename * -pin VSS -verbose

source scripts/Pgpin.tcl 

selectIOPin *
dbGet selected.net.name
set IOPINS [dbGet selected.name] 
foreach pin $IOPINS { deselectAll ; selectIOPin $pin; eval " add_shap -net [dbGet selected.name] -layer [dbGet selected.layer.name] -rect [dbGet selected.pinshapes.rect]"}

ecoRoute
#optDesign -postRoute -setup -hold
#optDesign -postRoute 
#refinePlace -eco true -hardFence false

#ecoRoute

timeDesign -postRoute -outDir report/route/routeTimingReports


saveDesign DESIGN/route.inn

source scripts/fillercell.tcl
addFiller -cell $FILL
ecoRoute
#setOptMode -opt_allow_only_cell_swapping true
#optDesign -postRoute



verify_drc -limit 9999999
#export design 
saveNetlist output/picosoc_pnr.v -includePhysicalinst -includePowerGround -excludeCellInst { FILL1 FILL2 FILL4 FILL8 FILL16 FILL32}

streamOut -merge "/pdk/sky130_scl_9T_0.1.2/sky130_scl_9T/gds/sky130_scl_9T.gds /pdk/sky130_scl_9T_0.1.2/sky130_scl_9T_HS/gds/sky130_scl_9T_HS.gds /pdk/sky130_scl_9T_0.1.2/sky130_scl_9T_tech/gds/sky130_scl_9T_phyCells.gds /pdk/sky130_scl_9T_0.1.2/sky130_scl_9T_LP/gds/sky130_scl_9T_LP.gds " -mapFile /pdk/sky130_scl_9T_0.1.2/sky130_scl_9T/gds/sky130_stream.mapFile output/darkram.gds

defOut -netlist -floorplan output/darkram.def
write_lef_abstract -stripePin -PGPinLayers { 4 5 } output/darkram.lef
set_analysis_view -setup {func_slow_125_1v0 func_typical_0_1v2 func_fast_0_1v2 } -hold {func_slow_125_1v0 func_typical_0_1v2 func_fast_0_1v2 }
do_extract_model -view func_slow_125_1v0 output/darkram_slow.lib
do_extract_model -view func_fast_0_1v2 output/darkram_fast.lib
do_extract_model -view func_typical_0_1v2 output/darkram_typical.lib

saveDesign DESIGN/route_drc.inn
#exit





