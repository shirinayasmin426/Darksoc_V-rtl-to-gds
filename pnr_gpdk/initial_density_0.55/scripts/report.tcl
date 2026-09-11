#source scripts/fillercell.tcl
#addFiller -cell $FILL
#ecoRoute

#verify_drc -limit 9999999
#export design 
saveNetlist output/darksocv_gpdk_pnr.v -includePhysicalinst -includePowerGround -excludeCellInst { FILL1 FILL2 FILL4 FILL8 FILL16 FILL32}

streamOut -merge "/pdk/sky130_scl_9T_0.1.2/sky130_scl_9T/gds/sky130_scl_9T.gds /pdk/sky130_scl_9T_0.1.2/sky130_scl_9T_HS/gds/sky130_scl_9T_HS.gds /pdk/sky130_scl_9T_0.1.2/sky130_scl_9T_tech/gds/sky130_scl_9T_phyCells.gds /pdk/sky130_scl_9T_0.1.2/sky130_scl_9T_LP/gds/sky130_scl_9T_LP.gds " -mapFile /pdk/sky130_scl_9T_0.1.2/sky130_scl_9T/gds/sky130_stream.mapFile output/darksocv_gpdk.gds

defOut -netlist -floorplan output/darksocv_gpdk.def
write_lef_abstract -stripePin -PGPinLayers { 4 5 } output/darksocv_gpdk.lef
set_analysis_view -setup {func_slow_125_1v0 func_fast_0_1v2} -hold {func_slow_125_1v0 func_fast_0_1v2 }
do_extract_model -view func_slow_125_1v0 output/darksocv_gpdk_slow.lib
do_extract_model -view func_fast_0_1v2 output/darksocv_gpdk_fast.lib
do_extract_model -view func_typical_0_1v2 output/darksocv_gpdk_typical.lib
saveDesign DESIGN/route_drc.inn

