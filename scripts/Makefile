#BLOCK:=darksocv

init:
	innovus -init $@.tcl -log logs/$@.log
fp2:init
	innovus -init $@.tcl -log logs/$@.log
place: fp2
	innovus -init $@.tcl -log logs/$@.log

CTS: place
	innovus -init $@.tcl -log logs/$@.log

route: CTS
	innovus -init $@.tcl -log logs/$@.log
#lvs: route 
#	mkdir -p phy_ver ; \
#	mkdir -p phy_ver/LVS ; \
#	cd phy_ver/LVS \
#	v2cdl -v ../output_copy/output/$(BLOCK)_pnr.v -o $(BLOCK).cdl -s0 VSS -s1 VDD -s "/pdk/gpdk045/gsclib045_all_v4.8/gsclib045/cdl/gsclib045.cdl /pdk/gpdk045/gsclib045_all_v4.8/gsclib045_lvt/cdl/gsclib045_lvt.cdl /pdk/gpdk045/gsclib045_all_v4.8/gsclib045_hvt/cdl/gsclib045_hvt.cdl" -lsr "/pdk/gpdk045/gsclib045_all_v4.8/gsclib045/cdl/gsclib045.cdl /pdk/gpdk045/gsclib045_all_v4.8/gsclib045_lvt/cdl/gsclib045_lvt.cdl /pdk/gpdk045/gsclib045_all_v4.8/gsclib045_hvt/cdl/gsclib045_hvt.cdl" -exclude_empty_module ; \
#	pegasus -lvs -gds ../output_copy/output/$(BLOCK).gds -top_cell $(BLOCK) -source_cdl $(BLOCK).cdl -source_top_cell $(block) -automatch -run_dir runDir_LVS -log_dir LOGS -ui_data /pdk/gpdk045/gpdk045_v_6_0/pvs/pvlLVS.rul 2>&1 | tee pegasus.log.1
