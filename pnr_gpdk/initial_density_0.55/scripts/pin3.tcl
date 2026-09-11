set start_offset 530
set pitch 3.0
set i 0

foreach pin [get_db ports -if {.direction == in}] {
set pin_name [get_db $pin .name]

    set offset [expr {$start_offset + ($i * $pitch)}]
    if {($i % 2) == 0} {
        editPin \
            -fixOverlap 1 \
            -spreadDirection clockwise \
	    -spreadType START \
            -edge 0 \
            -layer 6 \
            -offsetStart $offset \
            -pin $pin_name
    } else {
        editPin \
            -fixOverlap 1 \
            -spreadDirection clockwise \
            -spreadType START \
            -edge 0 \
            -layer 8 \
            -offsetStart $offset \
            -pin $pin_name
    }

    incr i
}



#output
set start_offset 500
set pitch 3.0
set i 0
foreach pin [get_db ports -if {.direction == out }] {

    set pin_name [get_db $pin .name]
    set offset [expr {$start_offset + ($i * $pitch)}]
    if {($i % 2) == 0} {
        editPin \
            -fixOverlap 1 \
            -spreadDirection clockwise \
            -spreadType START \
            -edge 2 \
            -layer 6 \
            -offsetStart $offset \
            -pin $pin_name
    } else {
        editPin \
            -fixOverlap 1 \
            -spreadDirection clockwise \
            -spreadType START \
            -edge 2 \
            -layer 8 \
            -offsetStart $offset \
            -pin $pin_name
    }

    incr i
}

