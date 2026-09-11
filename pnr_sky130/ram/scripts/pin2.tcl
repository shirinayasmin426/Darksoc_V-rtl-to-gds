set start_offset 1500
set j 0.30
for {set i 0} {$i <= 14} {incr i} {
        set pin_name "IPORT\[$i\]"
        set offset [expr {$start_offset + ($i * $j)}]
                if {($i % 2) == 0} {
                        editPin \
                                -fixOverlap 1 \
                                -spreadDirection clockwise \
                                -edge 1 \
                                -layer 2 \
                                -offsetStart $offset \
                                -pin $pin_name
                        }
                else {
                        editPin \
                                -fixOverlap 1 \
                                -spreadDirection clockwise \
                                -edge 1 \
                                -layer 4 \
                                -offsetStart $offset \
                                -pin $pin_name
                        }}

