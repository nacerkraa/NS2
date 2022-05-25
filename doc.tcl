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
