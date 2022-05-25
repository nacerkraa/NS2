set a 10 ; # To set a value to a variable

while {$a > 1} {
    puts "Hello world!"
    set a [expr $a - 1]
}
