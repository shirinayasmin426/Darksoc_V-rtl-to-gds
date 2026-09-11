# ####################################################################

#  Created by Genus(TM) Synthesis Solution 21.18-s082_1 on Sun Jul 19 15:03:22 +06 2026

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design picosoc

set_clock_gating_check -setup 0.0 
