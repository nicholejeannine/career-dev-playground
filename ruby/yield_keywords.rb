def pass_control
    puts "I'm at the start of the pass control method"
    puts yield
    puts "I'm at the end of the pass control method"
    puts "Arg called: #{yield}"
end

# LocalJumpError if no block passed
# pass_control { "I'm a block being passed"}
# pass_control { 'call me again' }

# Block implicitly returns the last evaluation to the method

# block_given? method - "predicate method" means it ends with ? (in Ruby) - returns a boolean

# We can allow a method to run with or without a block (so if no block, we don't get LocalJumpError)

def pass_control_on_condition
    puts "Inside new method"
    if block_given?
        the_arg = yield
        puts "#{the_arg} was given"
    end
    puts "back inside the method"
end

pass_control_on_condition
pass_control_on_condition { "I'm the arg!" }