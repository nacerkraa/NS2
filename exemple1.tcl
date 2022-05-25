# Cr�ation d'un simulateur
set ns [new Simulator]
# Cr�ation du fichier de trace utilis� par le visualisateur
set nf [open out.nam w]
# Indique � NS de logguer ses traces dans le fichier $nf (out.nam)
$ns namtrace-all $nf
# Lorsque la simulation sera termin�e, cette proc�dure sera appel�e
# pour lancer automatiquement le visualisateur (NAM)
proc finish {} {
# Force l'�criture dans le fichier des infos de trace
global ns nf
$ns flush-trace
close $nf
# Lance l'outil de visualisation nam
exec nam out.nam &
# Quitte le script TCL
exit 0
}
# cr�ation de deux noeuds
set n0 [$ns node]
set n1 [$ns node]
# Cr�ation d'une liaison de communication full duplex entre les noeuds n0 & n1
# Fonctionne � 1Mbps, 10ms de d�lai, et utilise l'algorithme de file DropTail
$ns duplex-link $n0 $n1 1Mb 10ms DropTail
# cr�ation d'un agent UDP implant� dans n0
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0
# Cr�ation d'un traffic CBR pour le noeud 0 g�n�rateur de paquets � vitesse
#constante
# Paquets de 500 octets (4000 bits), g�n�r�s toutes les 5 ms.
# ---> Ceci repr�sente un trafic de 800 000 bps (inf�rieur � la capacit� du
#lien)
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 500
$cbr0 set interval_ 0.005
# Ce traffic est attach� � l'agent UDP udp0
$cbr0 attach-agent $udp0
# Cr�ation d'un agent vide, destin� � recevoir les paquets dans le noeud n1
set null0 [new Agent/Null]
$ns attach-agent $n1 $null0
# Le trafic issu de l'agent udp0 est envoy� vers null0
$ns connect $udp0 $null0
# D�but de l'envoi du CBR � 0.5s apr�s le d�but de la simulation
$ns at 0.5 "$cbr0 start"
# Fin de l'envoi du CBR � 4.5s apr�s la fin de la simulation
$ns at 4.5 "$cbr0 stop"
# La simulation s'arr�te apr�s 5 secondes, et appelle la proc�dure
# TCL nomm�e "finish" d�finie pr�c�demment
$ns at 5.0 "finish"
# D�marrage du moteur de simulation
$ns run
