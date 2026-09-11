proc place_pins_odd_even_met4_met2 {args} {
set layer1  "met4"
set layer2  "met2"
set side    "Top"
set spacing 2.0
foreach {key val} $args {
switch -- $key {
-layer1  { set layer1  $val }
            -layer2  { set layer2  $val }
            -side    { set side    $val }
            -spacing { set spacing $val }
            default  { puts "WARNING: unknown option $key, ignoring" }
        }
    }

set allPins [lsort -dictionary [dbGet top.terms.name]]
 
    if {[llength $allPins] == 0} {
        puts "ERROR: No pins/terms found on top design. Nothing to place."
        return
    }
 
    puts "INFO: Found [llength $allPins] pins/bus-bits to place across $layer1 / $layer2."
 set idx          0
    set count_layer1 0
    set count_layer2 0
 
    foreach pinName $allPins {
        incr idx
 
        if {[expr {$idx % 2}] == 1} {
            set layer $layer1
            incr count_layer1
        } else {
            set layer $layer2
            incr count_layer2
        }
 
        if {[catch {
            editPin -pin $pinName \
                    -layer $layer \
                    -side  $side \
                    -spreadType SIDE \
                    -spacing $spacing \
                    -fixOverlap 1
        } errMsg]} {
            puts "WARNING: failed to place pin '$pinName' on $layer: $errMsg"
        } else {
            puts "INFO: \[$idx\] $pinName -> layer=$layer side=$side"
        }
    }
 
    puts "-----------------------------------------------------------"
    puts "DONE. Total pins placed : $idx"
    puts "  -> $layer1 (odd)  : $count_layer1"
    puts "  -> $layer2 (even) : $count_layer2"
    puts "-----------------------------------------------------------"
}
