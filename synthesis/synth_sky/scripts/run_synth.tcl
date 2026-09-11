source newhdl
source set_lib
source read_lef

set_db / .library $libs
read_hdl -v $hdl
set_db / .lef_library $lefs

set_db boundary_optimize_constant_hpins false
set_db / .auto_ungroup none

elaborate
set_top_module darksocv
write_do_lec -revised_design design_elaborated -logfile logs/lec_elab.log >output/elaborate.lec.do
write_hdl > output/elaborate.v

read_sdc sdc
report_clocks

set_db syn_global_effort high
set_db syn_generic_effort express
set_db syn_map_effort high 
set_db tns_opto true

syn_generic
write_hdl > output/generic.v

syn_map
write_hdl > output/map.v

syn_opt
write_hdl > output/opt.v

report_qor > reports/qor.rpt
report_timing > reports/timing.rpt
report_area > reports/area.rpt
report_power > reports/power.rpt

write_sdc > output/darksocv.sdc
write_sdf > output/darksocv.sdf
echo "Synthesis Completed Successfully!"
