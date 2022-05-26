set a 14 ; # To set a value to a variable
set x $a  ; # affectation
set r [expr $a + 10]

puts $a  ; # To print the value

puts -nonewline "this a line"

# if statment
if {$a > 10} {
    puts "a is greater then 10"
}

# if else
if [expr $a > 10] {
    puts "a is greater then 10"
} else {
    puts "a is less then 10"
    
}

# Simulation

# create the Simulator
set ns [new Simulator]

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
set sink [new Agent/TCPSink] ; # as a tcp receiver 

# atach the first agent to the first node 
# and the second agent to the second node

$ns attach-agent $n0 $tcp1
$ns attach-agent $n1 $sink

# astablish the connectoin betweent the two agent
$ns connect $tcp1 $sink

# create an application and attach it
set ftp [new Application/FTP]
$ftp attach-agent $tcp1


# create a procidure
proc finish {} {
    global ns tr ftr
    $ns flush-trace
    close $tr
    close $ftr
    exec nam out.nam &
    exit
}

# spicify what time we whant to trigger
$ns at .1 "$ftp start"
$ns at 2.0 "$ftp stop"

$ns at 2.1 "finish"

$ns run
