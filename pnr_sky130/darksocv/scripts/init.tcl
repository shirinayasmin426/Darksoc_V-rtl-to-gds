set init_gnd_net VSS
set init_pwr_net VDD

set init_lef_file {/pdk/sky130_scl_9T_0.1.2/sky130_scl_9T_tech/lef/sky130_scl_9T.tlef \
/pdk/sky130_scl_9T_0.1.2/sky130_scl_9T_tech/lef/sky130_scl_9T_phyCells.lef \
/pdk/sky130_scl_9T_0.1.2/sky130_scl_9T/lef/sky130_scl_9T.lef \
/pdk/sky130_scl_9T_0.1.2/sky130_scl_9T_LP/lef/sky130_scl_9T_LP.lef \
/pdk/sky130_scl_9T_0.1.2/sky130_scl_9T_HS/lef/sky130_scl_9T_HS.lef \
/pnr_training/WORK_BATCH1/shiri_41/pnrdark/darkram2/tempus_eco4/output/darkram.lef }

set init_verilog /pnr_training/WORK_BATCH1/shiri_41/pnrdark/darksocv_sky/synth/test1/output/opt.v
set init_top_cell darksocv
set init_mmmc_file scripts/viewDefinition.tcl
init_design
saveDesign DESIGN/init.inn
#exit
