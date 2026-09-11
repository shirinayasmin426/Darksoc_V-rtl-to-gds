
proc autoCreatePGPin {net_list} {
foreach net $net_list { puts "working on: $net"
set net_ptr [dbGet -p top.nets.name $net]
if {$net_ptr == "0x0" || $net_ptr == ""} {continue}
set all_swires [dbGet $net_ptr.sWires]
if {$all_swires == "0x0" || $all_swires == ""} {continue}
set success_count 0
foreach swire $all_swires { set layer [dbGet $swire.layer.name]
set raw_box [dbGet $swire.box]
if {$raw_box == "0x0" || $raw_box == ""} {continue}

set loc [lindex $raw_box 0]
set llx [lindex $loc 0]
set lly [lindex $loc 1]
set urx [lindex $loc 2]
set ury [lindex $loc 3]
set net_layer "${net}_${layer}_[expr int($llx)]_[expr int($lly)]"
if { ![catch { createPGPin $net -net $net -geom $layer $llx $lly $urx $ury } ]} { incr success_count } } 
puts "SUCCESS" } } 


autoCreatePGPin "VDD VSS"
