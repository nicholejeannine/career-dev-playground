puts "Ruby #{RUBY_VERSION}"
puts "-" * 60 # visual separator

#
# Example 1: Keyword args forwarding (breaks in Ruby 3)
#

def greet(name:)
  puts "Hello #{name}"
end

def old_wrapper(*args)
  greet(*args)
end

puts "\nExample 1"
old_wrapper(name: "Amy")


#
# Example 2: Correct keyword forwarding
#

def new_wrapper(*args, **kwargs)
  greet(*args, **kwargs)
end

puts "\nExample 2"
new_wrapper(name: "Amy")


#
# Example 3: Ruby 2.7 argument forwarding (...)
#

def forwarding_wrapper(...)
  greet(...)
end

puts "\nExample 3"
forwarding_wrapper(name: "Amy")


#
# Example 6: Numbered block params
#

puts "\nExample 6"

p [1, 2, 3].map { _1 * 10 }


#
# Example 7: Beginless range
#

puts "\nExample 7"

p (..5).include?(3)
p (..5).include?(100)


#
# Example 8: Endless range
#

puts "\nExample 8"

p (5..).include?(1000)


#
# Example 9: Filter with endless range
#

puts "\nExample 9"

scores = [50, 75, 90, 100]
p scores.select { _1 in 90.. }


#
# Example 10: Hash shorthand pattern matching
#

puts "\nExample 10"

user = {
  name: "Amy",
  role: "admin"
}

case user
in { role: "admin", name: }
  puts "Admin: #{name}"
end


#
# Example 11: Proc composition
#

puts "\nExample 11"

double = -> x { x * 2 }
plus_one = -> x { x + 1 }

combined = double >> plus_one

puts combined.call(10)


#
# Example 12: Enumerable#filter_map
#

puts "\nExample 12"

p [1, 2, 3, 4].filter_map { |n| n * 10 if n.even? }


#
# Example 13: then()
#

puts "\nExample 13"

result =
  "amy"
    .then(&:upcase)
    .then { "#{_1}!" }

puts result


#
# Example 14: Endless method definition
# (Ruby 3+)
#

# def active? = true
# puts active?


#
# Example 15: Find pattern
# (Ruby 2.7 experimental, later stabilized)
#

puts "\nExample 15"

values = [1, 2, 3, 4]

case values
in [*, 3, *]
  puts "Contains 3"
end

# Ruby 2.7+ only
def wrapper(...)
  target(...)
end

# Ruby 2.7+ only
case { name: "Amy", age: 42 }
in { name:, age: }
  puts "#{name} is #{age}"
end

# Ruby 2.7+ only
[1, 2, 3].map { _1 * 10 }

# Ruby 2.7+ only
p [1, nil, 2, false, 3].filter_map { |x| x * 2 if x }

#
# Example 4: Pattern matching
#

puts "\nExample 4"

data = { name: "Amy", age: 42 }

case data
in { name:, age: }
  puts "#{name} is #{age}"
end


#
# Example 5: Array pattern matching
#

puts "\nExample 5"

response = [200, "OK"]

case response
in [200, body]
  puts body
in [404, _]
  puts "Not found"
end