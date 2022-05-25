# Création d'un simulateur
set ns [new Simulator]
# Création du fichier de trace utilisé par le visualisateur
set nf [open out.nam w]
# Indique à NS de logguer ses traces dans le fichier $nf (out.nam)
$ns namtrace-all $nf
# Lorsque la simulation sera terminée, cette procédure sera appelée
# pour lancer automatiquement le visualisateur (NAM)
proc finish {} {
# Force l'écriture dans le fichier des infos de trace
global ns nf
$ns flush-trace
close $nf
# Lance l'outil de visualisation nam
exec nam out.nam &
# Quitte le script TCL
exit 0
}
# création de deux noeuds
set n0 [$ns node]
set n1 [$ns node]
# Création d'une liaison de communication full duplex entre les noeuds n0 & n1
# Fonctionne à 1Mbps, 10ms de délai, et utilise l'algorithme de file DropTail
$ns duplex-link $n0 $n1 1Mb 10ms DropTail
# création d'un agent UDP implanté dans n0
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0
# Création d'un traffic CBR pour le noeud 0 générateur de paquets à vitesse
#constante
# Paquets de 500 octets (4000 bits), générés toutes les 5 ms.
# ---> Ceci représente un trafic de 800 000 bps (inférieur à la capacité du
#lien)
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 500
$cbr0 set interval_ 0.005
# Ce traffic est attaché à l'agent UDP udp0
$cbr0 attach-agent $udp0
# Création d'un agent vide, destiné à recevoir les paquets dans le noeud n1
set null0 [new Agent/Null]
$ns attach-agent $n1 $null0
# Le trafic issu de l'agent udp0 est envoyé vers null0
$ns connect $udp0 $null0
# Début de l'envoi du CBR à 0.5s après le début de la simulation
$ns at 0.5 "$cbr0 start"
# Fin de l'envoi du CBR à 4.5s après la fin de la simulation
$ns at 4.5 "$cbr0 stop"
# La simulation s'arrête après 5 secondes, et appelle la procédure
# TCL nommée "finish" définie précédemment
$ns at 5.0 "finish"
# Démarrage du moteur de simulation
$ns run
