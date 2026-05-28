# blocks are inline. Perfect for simple operations or one-off logic bits.

# Proc - an object representation of a block
# Name "proc" is for "procedure" (procedure block)

to_cubes = Proc.new { |num| num ** 3 } # ** syntax means to the power of (num)
# can also use proc without `.new` or either with do/end sntax

# p to_cubes.call(3)

# Given
a = [1,2,3,4,5]
b = [6,7,8,9,10]
c = [11, 12, 13, 14, 15]

# Can write
# p a.map { |num| num ** 3 }
# p b.map { |num| num ** 3 }
# p c.map { |num| num ** 3 }

# But instead with a proc

p a.map(&to_cubes) # &: doesn't work but &proc works
p b.map(&to_cubes)
p c.map(&to_cubes)

is_senior = proc { |age| age > 60 }
ages = [10, 20, 30, 40, 61, 66]
p ages.select(&is_senior)

# methods with proc params
# When a method expects a block, ruby
# enables it to be a proc and v/v

# Whenever we pass a proc as an arg
# we also use the & which tells ruby
# it is a proc object
def talk_about(name, &my_proc)
    puts "let me tell you about #{name}"
    my_proc.call(name)
end

def talk_about_2(name)
    puts "Let me tell you about #{name}"
    yield(name)
end