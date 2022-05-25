########################################
### simulaton app form the scratch #####
########################################

# create the simulater
set ns [new Simulater]

# create two files to save the simulation in it
set tr [open "out.tr" w]
$ns trace-all $tr

set ftr [open "out.nam" w]
$ns namtrace-all $ftr

# create two nodes
set n0 [$ns node]
set n1 [$ns node]

# stablish a connection between the two nodes
$ns duplex-link $n0 $n1 2Mb 4ms DropTail



