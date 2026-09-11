
export PEGASUS_DRC="/pdk/sky130_release_0.1.0/Sky130_DRC/"

pegasus -drc -gds /pnr_training/WORK_BATCH1/shiri_41/pnrdark/darkram2/phy_ver/GDS_flow/darkram.wFill.gds.gz -top_cell darkram -run_dir runDir_DRC -log_dir LOGS /pdk/sky130_release_0.1.0/Sky130_DRC/sky130_rev_0.0_2.12.drc.pvl 2>&1 | tee drc.log



