set start_offset 10.0;
set track_spacing 0.20;
set current_offset $start_offset

for {set i 0} {$i<32} {incr i} {
        set pin_name "IPORT\[$i\]"

        if {[expr {$i % 2} == 0]} {
         set current_layer "Metal3"
        } else {
         set current_layer "Metal5"
        }

        editPin -pin $pin_name -layer $current_layer -edge 0 -spreadType start -offsetStart $current_offset -spacing $track_spacing -fixOverlap 1 -unit MICRON -spreadDirection clockwise -pinWidth 0.06 -pinDepth 0.335

        set current_offset [expr {$current_offset + $track_spacing}]
