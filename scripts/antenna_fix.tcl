set report "scripts/darkram.viols.drc"
set diode  "ANTENNA"
set log    "scripts/antenna_fix.log"

set fp [open $report r]
set lf [open $log w]

foreach line [split [read $fp] "\n"] {

if {[regexp {PIN:\s+(\S+)\s+\(\S+\)\s+(\S+)} $line -> inst pin]} {

        puts "Fixing: $inst $pin"
        puts $lf "Fixing: $inst $pin"

        if {[catch {
            attachDiode -diodeCell $diode -pin $inst $pin
        } err]} {
            puts "FAILED: $inst $pin"
            puts "ERROR: $err"

 puts $lf "FAILED: $inst $pin"
            puts $lf "ERROR: $err"
        } else {
            puts "OK: $inst $pin"
            puts $lf "OK: $inst $pin"
        }
    }
}

close $fp
close $lf

puts "Antenna diode insertion complete."
puts "Log file: $log"

refinePlace
