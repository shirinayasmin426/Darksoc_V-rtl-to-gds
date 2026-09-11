set_db / .max_cpus_per_server 4

source scripts/newhdl
source scripts/set_lib
source scripts/read_lef


set_db / .library $libs
#set_db [get_db cells *ICG*] .dont_use false
read_hdl -sv $hdl
set_db / .lef_library $lefs

set_db boundary_optimize_constant_hpins false
set_db / .auto_ungroup none

elaborate
set_top_module darksocv
write_do_lec -revised_design design_elaborated -logfile logs/lec_elab.log >output/elaborate.lec.do
check_design -all
report_hierarchy
write_hdl > output/elaborate.v

read_sdc scripts/sdc
report_clocks

set_db syn_global_effort high
set_db syn_generic_effort express
set_db syn_map_effort high 
set_db tns_opto true

set_db / .syn_generic_effort high
syn_generic
write_hdl > output/generic.v

set_db / .syn_map_effort high
syn_map
write_hdl > output/map.v

set_db / .syn_map_effort high
syn_opt
write_hdl > output/opt.v

write_do_lec -golden_design fv_map -revised_design outputs/gate_netlist.v -logfile logs/intermediate2final.lec.log > output/intermediate2final.lec.do
write_do_lec -revised_design outputs/gate_netlist.v -logfile logs/rtl2final.lec.log > outputs/rtl2final.lec.do

write_db -all_root_attributes -to_file genus_db/synopt.db


report_qor > reports/qor.rpt
report_timing > reports/timing.rpt
report_area > reports/area.rpt
report_power > reports/power.rpt
report_timing -unconstrained > reports/unconstrained_paths.rpt

write_sdc > output/darksocv.sdc
write_sdf > output/darksocv.sdf
echo "Synthesis Completed Successfully!"
