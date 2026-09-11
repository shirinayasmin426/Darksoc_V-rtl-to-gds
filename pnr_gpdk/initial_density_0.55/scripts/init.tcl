set init_gnd_net VSS
set init_pwr_net VDD
set init_lef_file {/pdk/gpdk045/gsclib045_all_v4.8/gsclib045/lef/gsclib045_tech.lef /pdk/gpdk045/gsclib045_all_v4.8/gsclib045/lef/gsclib045_macro.lef /pdk/gpdk045/gsclib045_all_v4.8/gsclib045_hvt/lef/gsclib045_hvt_macro.lef /pdk/gpdk045/gsclib045_all_v4.8/gsclib045_lvt/lef/gsclib045_lvt_macro.lef}
set init_verilog /pnr_training/WORK_BATCH1/shiri_41/pnrdark/darksocv_gpdk/synth/test2/output/opt.v
set init_top_cell darksocv
set init_mmmc_file scripts/viewDefinition.tcl
init_design
saveDesign DESIGN/init.inn

