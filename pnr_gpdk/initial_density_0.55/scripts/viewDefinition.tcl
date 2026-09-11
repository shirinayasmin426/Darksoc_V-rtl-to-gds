create_rc_corner -name rcworst \
-T 125 \
-qx_tech_file  /pdk/gpdk045/gpdk045_v_6_0/qrc/rcworst/qrcTechFile \

create_library_set -name slow_libs \
-timing  \
{/pdk/gpdk045/gsclib045_all_v4.8/gsclib045/timing/slow_vdd1v0_basicCells.lib \
/pdk/gpdk045/gsclib045_all_v4.8/gsclib045_hvt/timing/slow_vdd1v0_basicCells_hvt.lib \
/pdk/gpdk045/gsclib045_all_v4.8/gsclib045_lvt/timing/slow_vdd1v0_basicCells_lvt.lib } 

create_delay_corner -name rcworst_slow -library_set slow_libs -rc_corner rcworst

create_constraint_mode -name func_slow -sdc_files /pnr_training/WORK_BATCH1/shiri_41/pnrdark/darksocv_gpdk/synth/test2/output/darksocv.sdc

create_analysis_view -name func_slow_125_1v0 -constraint_mode func_slow -delay_corner rcworst_slow

create_rc_corner -name rcbest \
-T 0 \
-qx_tech_file  /pdk/gpdk045/gpdk045_v_6_0/qrc/rcbest/qrcTechFile \

create_library_set -name fast_libs \
-timing  \
{/pdk/gpdk045/gsclib045_all_v4.8/gsclib045/timing/fast_vdd1v2_basicCells.lib \
/pdk/gpdk045/gsclib045_all_v4.8/gsclib045_hvt/timing/fast_vdd1v2_basicCells_hvt.lib \
/pdk/gpdk045/gsclib045_all_v4.8/gsclib045_lvt/timing/fast_vdd1v2_basicCells_lvt.lib }

create_delay_corner -name rcbest_fast -library_set fast_libs -rc_corner rcbest

create_constraint_mode -name func_fast -sdc_files /pnr_training/WORK_BATCH1/shiri_41/pnrdark/darksocv_gpdk/synth/test2/output/darksocv.sdc

create_analysis_view -name func_fast_0_1v2 -constraint_mode func_fast -delay_corner rcbest_fast
set_analysis_view -setup {func_slow_125_1v0} -hold {func_fast_0_1v2}
