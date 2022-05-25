#Create a simulator object
set ns [new Simulator]
#Open trace files
set f [open out.tr w]
$ns trace-all $f
#Define a 'finish' procedure
proc finish {} {
global ns
$ns flush-trace
close $f
exit 0
}
#Create two nodes
set n0 [$ns node]
set n1 [$ns node]
#Create a duplex link between the nodes
$ns duplex-link $n0 $n1 1Mb 10ms DropTail
#Call the finish procedure after 5 seconds of simulation time
$ns at 5.0 "finish"
#Run the simulation
$ns run
