#source scripts/fillercell.tcl
#addFiller -cell $FILL
#ecoRoute

#verify_drc -limit 9999999
#export design 
saveNetlist output/darkram_pnr.v -includePhysicalinst -includePowerGround -excludeCellInst { FILL1 FILL2 FILL4 FILL8 FILL16 FILL32}

streamOut -merge "/pdk/sky130_scl_9T_0.1.2/sky130_scl_9T/gds/sky130_scl_9T.gds /pdk/sky130_scl_9T_0.1.2/sky130_scl_9T_HS/gds/sky130_scl_9T_HS.gds /pdk/sky130_scl_9T_0.1.2/sky130_scl_9T_tech/gds/sky130_scl_9T_phyCells.gds /pdk/sky130_scl_9T_0.1.2/sky130_scl_9T_LP/gds/sky130_scl_9T_LP.gds " -mapFile /pdk/sky130_scl_9T_0.1.2/sky130_scl_9T/gds/sky130_stream.mapFile output/darkram.gds

defOut -netlist -floorplan output/darkram.def
write_lef_abstract -stripePin -PGPinLayers { 4 5 } output/darkram.lef
set_analysis_view -setup {func_slow_125_1v0 func_typical_0_1v2 func_fast_0_1v2 } -hold {func_slow_125_1v0 func_typical_0_1v2 func_fast_0_1v2 }
do_extract_model -view func_slow_125_1v0 output/darkram_slow.lib
do_extract_model -view func_fast_0_1v2 output/darkram_fast.lib
do_extract_model -view func_typical_0_1v2 output/darkram_typical.lib

saveDesign DESIGN/route_drc.inn


