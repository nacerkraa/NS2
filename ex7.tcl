# cr�ation d'un simulateur
set ns [new Simulator]
$ns rtproto DV
set nf [open out.nam w]
$ns namtrace-all $nf
# lorsque la simulation sera termin�e, cette proc�dure est appel�e pour lancer
#automatiquement le visualisateur
proc finish {} {
global ns nf
$ns flush-trace
close $nf
exec nam out.nam &
exit 0
}
# Creating network nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
# Creating network links
$ns duplex-link $n0 $n1 1Mb 10ms DropTail
$ns duplex-link $n1 $n2 1Mb 10ms DropTail
$ns duplex-link $n2 $n3 1Mb 10ms DropTail
$ns duplex-link $n3 $n4 1Mb 10ms DropTail
$ns duplex-link $n4 $n5 1Mb 10ms DropTail
$ns duplex-link $n5 $n6 1Mb 10ms DropTail
$ns duplex-link $n6 $n0 1Mb 10ms DropTail

$ns duplex-link-op $n0 $n1 orient right-down
$ns duplex-link-op $n1 $n2 orient right
$ns duplex-link-op $n2 $n3 orient right-up
$ns duplex-link-op $n3 $n4 orient left-up
$ns duplex-link-op $n4 $n5 orient left
$ns duplex-link-op $n5 $n6 orient left
$ns duplex-link-op $n6 $n0 orient left-down
# On tente de r�duire la taille de la queue
#$ns queue-limit $n2 $n3 100
$ns duplex-link-op $n0 $n1 queuePos 0.5
$ns duplex-link-op $n1 $n2 queuePos 0.5
$ns duplex-link-op $n2 $n3 queuePos 0.5
$ns duplex-link-op $n3 $n4 queuePos 0.5
$ns duplex-link-op $n4 $n5 queuePos 0.5
$ns duplex-link-op $n5 $n6 queuePos 0.5
$ns duplex-link-op $n6 $n0 queuePos 0.5
# Cr�ation dun agent implant� dans n0
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0
# cr�ation d'un traffic CBR pour le noeud 0 g�n�rateur de paquets � vitesse
#constante paquets de 500 octets, g�n�r�s toutes les 5 ms. Ce traffic est
#attach� au udp0
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 500
$cbr0 set interval_ 0.005
$cbr0 attach-agent $udp0
# cr�ation d'un agent vide, destin� � recevoir les paquets implant� dans n3
set sink0 [new Agent/LossMonitor]
$ns attach-agent $n3 $sink0
# le trafic issus de l'agent udp0 est envoy� vers sink0
$ns connect $udp0 $sink0
# sc�nario de d�but et de fin de g�n�ration des paquets par cbr0
$ns at 0.5 "$cbr0 start"
$ns at 10.0 "$cbr0 stop"
$ns rtmodel-at 2.0 down $n1 $n2
$ns rtmodel-at 4.0 up $n1 $n2
# la simulation va durer 10.5 secondes de temps simul�
$ns at 10.5 "finish"
$udp0 set class_ 1
$ns color 1 Orange
# d�but de la simulation
$ns run