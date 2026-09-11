set report "scripts/darkram.viols.drc"
set diode  "ANTENNA"
set log    "scripts/antenna_fix.log"

set fp [open $report r]
set lf [open $log w]

set n 0

foreach line [split [read $fp] "\n"] {

    if {[regexp {PIN:\s+(\S+)\s+\(\S+\)\s+(\S+)} $line -> inst pin]} {

        incr n

        puts "Fixing: $inst $pin"
        puts $lf "Fixing: $inst $pin"


if {[catch {
            attachDiode -prefix ANT_DIODE_${n}_ \
                -diodeCell $diode \
                -pin $inst $pin
        } err]} {

            puts "FAILED: $inst $pin : $err"
            puts $lf "FAILED: $inst $pin : $err"

        } else {

            puts "Diode added: $inst $pin"
            puts $lf "Diode added: $inst $pin"
        }
    }
}

close $fp
close $lf

puts "Antenna diode insertion complete."
puts "Log: $log"

refinePlace
