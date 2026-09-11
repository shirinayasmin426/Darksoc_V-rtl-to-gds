# ####################################################################

#  Created by Genus(TM) Synthesis Solution 21.18-s082_1 on Sun Jul 12 04:58:34 +06 2026

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design darksocv

create_clock -name "CLK" -period 5.6 -waveform {0.0 2.8} [get_ports CLK]
set_clock_gating_check -setup 0.0 
