set a 14 ; # To set a value to a variable
set x $a  ; # affectation
set r [expr $a + 10]

puts $a  ; # To print the value

puts -nonewline "this a line"

if {$a > 10} {
    puts "a is greater then 10"
}
