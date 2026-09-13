#-----------------------------------------------------------------------
# scripts to generating power-grid library 
# Created for EPS by Bill Wareham
# updated to Voltus 13.2 by Rose Li Nov 2013
# updated to Voltus 14.1 by Rose Li April 2014
# updated to Voltus 15.1 by Rose Li July 2015
#-----------------------------------------------------------------------
set_distribute_host -local

set_multi_cpu_usage -local 16

#set_pg_library_mode -enable_distributed_processing true
#-----------------------------------------------------------------------
# Load LEF files
#-----------------------------------------------------------------------
read_lib \
    -lef \
/pdk/gpdk045/gsclib045_all_v4.8/gsclib045/lef/gsclib045_tech.lef \
/pdk/gpdk045/gsclib045_all_v4.8/gsclib045/lef/gsclib045_macro.lef \
/pdk/gpdk045/gsclib045_all_v4.8/gsclib045_hvt/lef/gsclib045_hvt_macro.lef \
/pdk/gpdk045/gsclib045_all_v4.8/gsclib045_lvt/lef/gsclib045_lvt_macro.lef
#-----------------------------------------------------------------------
# Technology library generation
#-----------------------------------------------------------------------
set_pg_library_mode \
    -ground_pins                {VSS ExtVSS} \
    -power_pins                 {VSS ExtVSS} \
    -decap_cells                {DECAP2 DECAP3 DECAP4 DECAP5 DECAP6 DECAP7 DECAP8 DECAP9 DECAP10} \
    -filler_cells               {FILL1 FILL1HVT FILL1LVT \
                                FILL2 FILL2HVT FILL2LVT \
                                FILL4 FILL4HVT FILL4LVT \
                                FILL8 FILL8HVT FILL8LVT \
                                FILL16 FILL16HVT FILL16LVT \
                                FILL32 FILL32HVT FILL32LVT \
                                FILL64 FILL64HVT FILL64LVT} \
    -default_area_cap           0.01 \
    -celltype                   techonly \
    -cell_decap_file            ../data/voltus/decap.cmd \
    -lef_layermap               ../data/voltus/lefdef.layermap \
    -extraction_tech_file       ../data/qrc/qrcTechFile \
    -powergate_parameters { {HSWCX1 ExtVDD VDD enableHigh}  }


generate_pg_library \
    -output                     tech_pgv

#-----------------------------------------------------------------------
# Standard cells pgv generation
#-----------------------------------------------------------------------
set_pg_library_mode \
    -ground_pins                VSS \
    -power_pins                 {VDD 1.1 TVDD 1.1} \
    -decap_cells                {DECAP2 DECAP3 DECAP4 DECAP5 DECAP6 DECAP7 DECAP8 DECAP9 DECAP10} \
    -filler_cells               {FILL1 FILL1HVT FILL1LVT \
                                FILL2 FILL2HVT FILL2LVT \
                                FILL4 FILL4HVT FILL4LVT \
                                FILL8 FILL8HVT FILL8LVT \
                                FILL16 FILL16HVT FILL16LVT \
                                FILL32 FILL32HVT FILL32LVT \
                                FILL64 FILL64HVT FILL64LVT} \
    -celltype                   stdcells \
    -cell_decap_file            ../data/voltus/decap.cmd \
    -cell_list_file 		../data/voltus/cell.list \
    -spice_subckts { \
        ../data/netlists/gsclib090.sp \
        ../data/netlists/pso_header.spi \
        ../data/netlists/pso_ring.spi \
    } \
    -lef_layermap               ../data/voltus/lefdef.layermap \
    -current_distribution       propagation \
    -spice_models               ../data/netlists/spectre_load.sp \
    -extraction_tech_file       ../data/qrc/qrcTechFile \
    -powergate_parameters { \
        {RING_SWITCH   TVDD VDD} \
        {HEADER_SWITCH TVDD VDD} \
    }

generate_pg_library \
    -output                     stdcell_pgv

#-----------------------------------------------------------------------
# Macro pll pgv generation
#-----------------------------------------------------------------------
#set_pg_library_mode \
    -gds_files                  ../data/gds/pll.gds \
    -ground_pins                VSS \
    -cell_list_file             ../data/voltus/macro.list \
    -power_pins                 {VDD 0.9} \
    -celltype                   macros \
    -spice_subckts              ../data/netlists/pll.sp \
    -gds_layermap               ../data/voltus/gds.layermap \
    -lef_layermap               ../data/voltus/lefdef.layermap \
    -stop@via                   CONT \
#    -spice_models               ../data/netlists/spectre_load.sp \
#    -current_distribution       propagation \
#    -extraction_tech_file       ../data/qrc/qrcTechFile

#generate_pg_library \
    -output                     macro_pgv/
