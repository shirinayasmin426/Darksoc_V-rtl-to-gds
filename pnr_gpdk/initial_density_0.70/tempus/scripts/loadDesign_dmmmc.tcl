#run directory-tempus
#set_top_module alu32 -ignore_undefined_cell
read_view_definition viewDefinition.tcl

read_verilog "/pnr_training/WORK_BATCH1/shiri_41/pnrdark/darksocv_gpdk2/output/darksocv_pnr.v"
set_top_module darksocv -ignore_undefined_cell
#read_def ../output/darksocv.def
#set_analysis_view \
        -setup {func_slow_125_1v0} \
        -hold {func_fast_0_1v2}

