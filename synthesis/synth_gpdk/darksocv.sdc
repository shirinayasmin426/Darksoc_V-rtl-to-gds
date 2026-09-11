# ####################################################################

#  Created by Genus(TM) Synthesis Solution 21.18-s082_1 on Thu Sep 03 03:51:15 +06 2026

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design darksocv

create_clock -name "CLK" -period 6.0 -waveform {0.0 3.0} [get_ports XCLK]
set_clock_gating_check -setup 0.0 
