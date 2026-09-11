create_rc_corner -name rcworst \
-T 125 \
-qx_tech_file  /pdk/sky130_release_0.1.0/quantus/extraction/typical/qrcTechFile \

create_library_set -name slow_libs \
-timing  \
{/pdk/sky130_scl_9T_0.1.2/sky130_scl_9T/lib/sky130_ss_1.62_125_nldm.lib.gz \
/pdk/sky130_scl_9T_0.1.2/sky130_scl_9T_LP/lib/sky130_ss_1.62_125_nldm.lib.gz \
/pdk/sky130_scl_9T_0.1.2/sky130_scl_9T_HS/lib/sky130_ss_1.62_125_nldm.lib.gz \
/pdk/sky130_scl_9T_0.1.2/sky130_scl_9T_tech/lib/sky130_scl_9T_phyCells.lib}

create_delay_corner -name rcworst_slow -library_set slow_libs -rc_corner rcworst

create_constraint_mode -name func_slow -sdc_files scripts/darksocv.sdc

create_analysis_view -name func_slow_125_1v0 -constraint_mode func_slow -delay_corner rcworst_slow


create_rc_corner -name rctypical \
-T 25 \
-qx_tech_file  /pdk/sky130_release_0.1.0/quantus/extraction/typical/qrcTechFile \

create_library_set -name typical_libs \
-timing  \
{/pdk/sky130_scl_9T_0.1.2/sky130_scl_9T/lib/sky130_tt_1.8_25_nldm.lib.gz \
/pdk/sky130_scl_9T_0.1.2/sky130_scl_9T_LP/lib/sky130_tt_1.8_25_nldm.lib.gz \
/pdk/sky130_scl_9T_0.1.2/sky130_scl_9T_HS/lib/sky130_tt_1.8_25_nldm.lib.gz \
/pdk/sky130_scl_9T_0.1.2/sky130_scl_9T_tech/lib/sky130_scl_9T_phyCells.lib}

create_delay_corner -name rctypical_typical -library_set typical_libs -rc_corner rctypical

create_constraint_mode -name func_typical -sdc_files scripts/darksocv.sdc


create_analysis_view -name func_typical_0_1v2 -constraint_mode func_typical -delay_corner rctypical_typical


create_rc_corner -name rcbest \
-T 0 \
-qx_tech_file  /pdk/sky130_release_0.1.0/quantus/extraction/typical/qrcTechFile \

create_library_set -name fast_libs \
-timing  \
{/pdk/sky130_scl_9T_0.1.2/sky130_scl_9T/lib/sky130_ff_1.98_0_nldm.lib.gz \
/pdk/sky130_scl_9T_0.1.2/sky130_scl_9T_LP/lib/sky130_ff_1.98_0_nldm.lib.gz \
/pdk/sky130_scl_9T_0.1.2/sky130_scl_9T_HS/lib/sky130_ff_1.98_0_nldm.lib.gz \
/pdk/sky130_scl_9T_0.1.2/sky130_scl_9T_tech/lib/sky130_scl_9T_phyCells.lib}

create_delay_corner -name rcbest_fast -library_set fast_libs -rc_corner rcbest

create_constraint_mode -name func_fast -sdc_files scripts/darksocv.sdc

create_analysis_view -name func_fast_0_1v2 -constraint_mode func_fast -delay_corner rcbest_fast
set_analysis_view -setup {func_slow_125_1v0 func_typical_0_1v2 func_fast_0_1v2 } -hold {func_slow_125_1v0 func_typical_0_1v2 func_fast_0_1v2 }
