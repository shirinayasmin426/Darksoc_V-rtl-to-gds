#-----------------------------------------------------------------------
# scripts to run static power and rail analysis
#-----------------------------------------------------------------------

#------------------------------------------------------
# set multi CPU
# ------------------------------------------------------
# large designs use XP flow, enable multi hosts, multi cpus
# set_multi_cpu_usage -localCpu 8 -remoteHost 1 -cpuPerRemoteHost 8
# set_distribute_host -custom -custom_script {bsub -q interactive -n 8 -R "(OSNAME == Linux ) && (OSREL==EE80) rusage[mem=50000]" -W 100:30 }
#
# for this RAK, we keep 1 host and multiple cpus
set_multi_cpu_usage \
        -localCpu                       8
set_distribute_host -local

#-----------------------------------------------------------------------
## load design
#-----------------------------------------------------------------------
set lefs [list]

lappend lefs /pdk/gpdk045/gsclib045_all_v4.8/gsclib045/lef/gsclib045_tech.lef
lappend lefs /pdk/gpdk045/gsclib045_all_v4.8/gsclib045/lef/gsclib045_macro.lef
lappend lefs /pdk/gpdk045/gsclib045_all_v4.8/gsclib045_hvt/lef/gsclib045_hvt_macro.lef
lappend lefs /pdk/gpdk045/gsclib045_all_v4.8/gsclib045_lvt/lef/gsclib045_lvt_macro.lef


read_lib -lef $lefs


read_view_definition /pnr_training/WORK_BATCH1/shiri_41/pnrdark/darksocv_gpdk/scripts/viewDefinition.tcl

read_verilog /pnr_training/WORK_BATCH1/shiri_41/pnrdark/darksocv_gpdk/output/darksocv_gpdk_pnr.v
set_top_module darksocv -ignore_undefined_cell

read_def /pnr_training/WORK_BATCH1/shiri_41/pnrdark/darksocv_gpdk/output/darksocv_gpdk.def

#-----------------------------------------------------------------------
# Read cpf file for power domain information 
#-----------------------------------------------------------------------
#read_power_domain -cpf ../design/super_filter.cpf

#-----------------------------------------------------------------------
# Read spef file
#-----------------------------------------------------------------------

read_spef -rc_corner rcbest -decoupled /pnr_training/WORK_BATCH1/shiri_41/pnrdark/darksocv_gpdk/SQRC_RUN/darksocv.rcbest.spef.gz
read_spef -rc_corner rcworst -decoupled /pnr_training/WORK_BATCH1/shiri_41/pnrdark/darksocv_gpdk/SQRC_RUN/darksocv.rcworst.spef.gz

#-----------------------------------------------------------------------
# Alternatively, you can read the design piece-meal.
# source ../tcl/load_design_voltus.tcl

#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# Static Power Analysis
#-----------------------------------------------------------------------
set_power_analysis_mode \
    -reset

set_power_analysis_mode \
    -leakage_power_view 	func_fast_0_1v2 \
    -dynamic_power_view        	func_fast_0_1v2 \
    -write_static_currents      true \
    -binary_db_name             power.db \
    -create_binary_db           true \
    -method                     static \
    -enable_xp true \
    -extraction_tech_file  /pdk/gpdk045/gpdk045_v_6_0/qrc/typical/qrcTechFile \
    -power_grid_library 	{ \
	/pdk/sky130_scl_9T_0.1.2/sky130_scl_9T/pgv/tech_pgv/techonly.cl \
	/pdk/sky130_scl_9T_0.1.2/sky130_scl_9T/pgv/stdcell_pgv/stdcells.cl \
	} 
#-----------------------------------------------------------------------
# to define power for instances that are missing .lib
#-----------------------------------------------------------------------
#set_power \
    -reset

#set_power \
    -cell                       pll \
    -pin                        VDD \
                                0.5
#set_power \
    -instance                   u0 \
    -pin                        VDD \
                                0.5
#-----------------------------------------------------------------------
# define switching activity for primary inputs/nets/clocks if they are not
# defined thru user attribute, TCF, VCD or clock constraints. Remember, Voltus
# will use the SDCs but that only controls clocks and registers. SDCs do not
# say how often clock gates toggle.
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# set toggle rate on the rst pin and propagate activities:
#-----------------------------------------------------------------------
set_switching_activity \
    -reset

set_switching_activity \
    -input_port                 rst \
    -activity                   0.25 \
    -duty                       0.30

propagate_activity

#-----------------------------------------------------------------------
# validate the activity was properly applied
#-----------------------------------------------------------------------
#get_activity \
    -port                       rst

#set_switching_activity \
#    -pin [ \
#        get_pins -of_objects [ \
#            get_cells RC_CGIC* -hierarchical \
#        ] \
#        -filter "@direction == out" \
#   ] \
#    -activity                   0.1

#propagate_activity

#-----------------------------------------------------------------------
# validate the activities was properly applied
#-----------------------------------------------------------------------
#get_activity \
#    -pin [ \
#        get_pins -of_objects [ \
#            get_cells RC_CGIC* -hierarchical \
#        ] \
#        -filter "@direction == out" \
#    ]

#-----------------------------------------------------------------------
# set default activities for all nets/pins/etc for unclocked nets
#-----------------------------------------------------------------------
set_default_switching_activity \
    -input_activity             0.3 \
    -period                     4.0 \
    -clock_gates_output_ratio   0.5

#-----------------------------------------------------------------------
# define output directory
#-----------------------------------------------------------------------
set_power_output_dir            staticPowerResults

#-----------------------------------------------------------------------
# run power analysis
#-----------------------------------------------------------------------
report_power \
    -outfile                    static.rpt

#-----------------------------------------------------------------------
# generate different report formats:
#-----------------------------------------------------------------------
#report_power -instances {u0}    -outfile u0.rpt
#report_power -instances {*}     -outfile all.rpt
#report_power -instances {ring}  -outfile ring.rpt

#suspend

##-----------------------------------------------------------------------
# plot instance power 
# you may need to type in: start_gui
# to see the plot
#-----------------------------------------------------------------------
read_power_rail_results \
    -power_db                   staticPowerResults/power.db

set_power_rail_display \
    -plot ip


#-----------------------------------------------------------------------
# plot instance power with modified filters
#-----------------------------------------------------------------------
#set_power_rail_display \
    -plot                       ip \
    -filter_max 		0.0038 \
    -filter_min			1.00001e-05

#-----------------------------------------------------------------------
# plot instance frequency
#-----------------------------------------------------------------------
set_power_rail_display \
    -plot                       freq 

#-----------------------------------------------------------------------
# plot transition density
#-----------------------------------------------------------------------
set_power_rail_display \
    -plot                       td

#-----------------------------------------------------------------------
# clear the display
#-----------------------------------------------------------------------
set_power_rail_display \
    -plot                       none

#resume#
#-----------------------------------------------------------------------
# Static Rail Analysis
#-----------------------------------------------------------------------

set_rail_analysis_mode \
    -method                     static \
    -accuracy                   xd \
    -analysis_view              func_fast_0_1v2  \
    -power_grid_library         { \
        /pdk/sky130_scl_9T_0.1.2/sky130_scl_9T/pgv/tech_pgv/techonly.cl \
        /pdk/sky130_scl_9T_0.1.2/sky130_scl_9T/pgv/stdcell_pgv/stdcells.cl \
    } \
    -enable_rlrp_analysis       true \
    -verbosity true \
    -temperature 125 \
    -enable_xp true \
    -extraction_tech_file  /pdk/gpdk045/gpdk045_v_6_0/qrc/typical/qrcTechFile

#in XP flow, power and rail can run in one command with the option:set_rail_analysis_mode -report_power_in_parallel true
#in this case, to add options to report_power use "-report_power_options {...}" switch in set_rail_analysis_mode 

#-----------------------------------------------------------------------
# How to control the views used in the analysis? -accuracy option
# xd - uses early view for all cells (fast performance)
# hd - uses IR view for macros and EM view for EM check
#
# To change the PGV selection or enable DFM effects, use the following 
# parameters of the set_rail_analysis_mode command:
#
#     -use_early_view_list filename
#     -use_ir_view_list filename
#     -use_em_view_list filename
#-----------------------------------------------------------------------


#-----------------------------------------------------------------------
# Define voltages and thresholds that are used by the rail analysis engine.
# -voltage....nominal rail voltage
# -threshold..minimum allowed voltage on the power net (or max rise on ground net)...
# it's used to set filter thresholds for IR plots.
#-----------------------------------------------------------------------
#set_pg_nets -net VDD_AO     -voltage 0.9 -threshold 0.85 -force
#set_pg_nets -net VDD_column -voltage 0.9 -threshold 0.85 -force
#set_pg_nets -net VDD_ring   -voltage 0.9 -threshold 0.85 -force
#set_pg_nets -net VSS        -voltage 0.0 -threshold 0.05 -force

set_pg_nets -net VDD       -voltage 1.1 -threshold 0.05 -force
set_pg_nets -net VSS        -voltage 0.0 -threshold 0.05 -force

set_rail_analysis_domain -name ALl -pwrnets VDD -gndnets VSS

#-----------------------------------------------------------------------
# define voltage source location
#-----------------------------------------------------------------------
##in XP flow, if running power in parallel of rail: comment set_power_pads and report_power commands
set_power_pads \
    -reset

set_power_pads \
    -net                        VDD \
    -format                     xy \
    -file                       ../design/darksocv_sky_VDD.pp

#set_power_pads \
#    -net                        VDD \
#   -format                     xy \
#   -file                       ../design/super_filter_VDD.pp

set_power_pads \
    -net                        VSS \
    -format                     xy \
    -file                       ../design/darksocv_sky_VSS.pp

#-----------------------------------------------------------------------
#define power consumption
#-----------------------------------------------------------------------
set_power_data -reset
set_power_data \
    -format                     current \
    { \
        staticPowerResults/static_VDD.ptiavg \
        staticPowerResults/static_VSS.ptiavg \
    }

#analyze_rail -type domain -output ./staticRailResults VDD
#analyze_rail -type net -output staticRailResults/ VDD
analyze_rail -type net -output staticRailResults/ VSS


#suspend
#resume
#-----------------------------------------------------------------------
# options to run other power domains and nets
#set_rail_analysis_domain -name PD_external	\
#-pwrnets VDD_external  -gndnets VSS -threshold 0.10
#set_rail_analysis_domain -name PD_AO 		\
#-pwrnets VDD_AO  -gndnets VSS -threshold 0.10
# 
# analyze_rail -results_directory ./staticRailResults -type domain PD_AO
# analyze_rail -results_directory ./staticRailResults -type net VDD_AO
# analyze_rail -results_directory ./staticRailResults -type net VSS
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# load analysis results
#-----------------------------------------------------------------------
read_power_rail_results -rail_directory staticRailResults/VSS_125C_avg_1

#read_power_rail_results -rail_directory staticRailResults/VDD 
#read_power_rail_results -rail_directory staticRailResults/ALL_125C_avg_1
#read_power_rail_results -rail_directory staticRailResults/VDD_125C_avg_1
#-----------------------------------------------------------------------
# View the results:
#-----------------------------------------------------------------------

set_power_rail_display \
    -plot 			ir

set_power_rail_display \
    -plot 			tc

set_power_rail_display \
    -plot 			pv

set_power_rail_display \
    -plot 			pi

#-----------------------------------------------------------------------
#what -if analysis
#-----------------------------------------------------------------------
scale_what_if_current \
    -global \
    -scale                      10

scale_what_if_resistance \
    -global \
    -net                        VDD \
    -layer                      met4 \
    -scale                      4 \
    -auto_scale_adjacent_via_layers                     true


analyze_rail \
    -results_directory          ./staticRailResults \
    -type                       net \
    -output                     staticRailResults VDD


#-----------------------------------------------------------------------
# load analysis results
#-----------------------------------------------------------------------
read_power_rail_results -reset
#read_power_rail_results -rail_directory staticRailResults/ALL_125C_avg_2

read_power_rail_results -rail_directory staticRailResults/VSS_125C_avg_1

#-----------------------------------------------------------------------
# View the results:
#-----------------------------------------------------------------------

set_power_rail_display \
   -plot 			ir

#---------------------END----------------------------------------------
