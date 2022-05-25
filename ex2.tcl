# Cr�ation du simulateur
set ns [new Simulator]
# Cr�ation du fichier de traces NS-2
set nf [open out.nam w]
$ns namtrace-all $nf
# Proc�dure de fin de simulation, qui �crit les donn�es dans le fichier
# et lance NAM pour la visualisation
proc finish {} {
global ns nf
$ns flush-trace
close $nf
exec nam out.nam &
exit 0
}
# Cr�ation des noeuds
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
# Cr�ation des liens, tous en 1Mbps/10ms de TR/file d'attente DropTail
$ns duplex-link $n0 $n2 1Mb 10ms DropTail
$ns duplex-link $n1 $n2 1Mb 10ms DropTail
$ns duplex-link $n3 $n2 1Mb 10ms DropTail
# Cr�ation de deux agents implant�s dans n0 et n1
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0
set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1
# Traffic CBR de 500 octets toutes les 5 ms pour UDP0
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 500
$cbr0 set interval_ 0.005
$cbr0 attach-agent $udp0
# Traffic CBR de 500 octets toutes les 5 ms pour UDP1
set cbr1 [new Application/Traffic/CBR]
$cbr1 set packetSize_ 500
$cbr1 set interval_ 0.005
$cbr1 attach-agent $udp1
# Cr�ation d'un agent vide, destin� � recevoir les paquets implant� dans n3
set null0 [new Agent/Null]
$ns attach-agent $n3 $null0
# Le trafic issu des agents udp0 et udp1 est envoy� vers null0
$ns connect $udp0 $null0
$ns connect $udp1 $null0
# Sc�nario de d�but et de fin de g�n�ration des paquets par cbr0
$ns at 0.5 "$cbr0 start"
$ns at 0.5 "$cbr1 start"
$ns at 4.5 "$cbr0 stop"
$ns at 4.5 "$cbr1 stop"
# La simulation va durer 5 secondes et appeller la proc finish
$ns at 5.0 "finish"
# Definition de classes pour la coloration
$udp0 set class_ 1
$udp1 set class_ 2
# Coloration des classes : bleu pour udp0 (classe 1) et rouge pour udp1
#(classe 2)
$ns color 1 Blue
$ns color 2 Red
# d�but de la simulation
$ns run