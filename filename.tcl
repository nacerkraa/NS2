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

# genirate trafic (many trafic are available)
# create agent (tcp, udp ...)
set tcp1 [new Agent/TCP]
set sink [new Agent/TCPSink] ;# as a tcp receiver 

# atach the first agent to the first node 
# and the second agent to the second node

$ns attach-agent $n0 $tcp1
$ns attach-agent $n1 $sink




