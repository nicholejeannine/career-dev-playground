puts "Ruby #{RUBY_VERSION}"
puts "-" * 60 # visual separator

# Get real examples from https://rubyreferences.github.io/rubychanges/3.0.html

# 1. Full separation of keyword arguments

def old_style(name, options = {})
  puts "#{name} was passed as a positional arg"
  puts options
end

def new_style(name, **options)
   puts "#{name} was passed as a positional arg"
   puts options
end

# Throws in 'new_style': wrong number of arguments (given 2, expected 1) (ArgumentError)
# new_style('John', {age: 10})

# Converting to kwargs with ** is mandatory
# new_style('John', **{age: 10})

# # Ruby 2.6: works
# # Ruby 2.7: warns: Using the last argument as keyword parameters is deprecated; maybe ** should be added to the call
# # Ruby 3.0: ArgumentError (wrong number of arguments (given 2, expected 1))
# new_style('John', age: 10)
# # => works
# h = {age: 10}
# new_style('John', **h)
# # => works, ** is mandatory

# # The last hash argument still allowed to be passed without {}:
# old_style('John', age: 10)
# => works


# 2. Arguments forwarding (...) supports leading arguments

def request(method, url, headers: {})
  puts "#{method.upcase} #{url} (headers=#{headers})"
end

def get(...)
  request(:get, ...)
end

get('https://example.com', headers: {content_type: 'json'})
# GET https://example.com (headers={:content_type=>"json"})

# Leading arguments may be present both in the call and in the definition:
def logged_get(message, ...)
  puts message
  get(...)
end

logged_get('Logging', 'https://example.com', headers: {content_type: 'json'})

=begin
Notes:
The adjustment was considered important enough to be backported to 2.7 branch;
“all arguments splat” ... should be the last statement in the argument list (both on a declaration and a call)
on a method declaration, arguments before ... can only be positional (not keyword) arguments, and can’t have default values (it would be SyntaxError);
on a method call, arguments passed before ... can’t be keyword arguments (it would be SyntaxError);
make sure to check your punctuation thoroughly, because anything ... is a syntax for endless range, those constructs are valid syntax, but would do not what is expected: 
In Ruby 3.1, a separate anonymous block argument (bare &) forwarding was added;
In Ruby 3.2, separate positional and keyword (bare * and **) forwarding were added.
=end

=begin
3. Endless method syntax
Rewriting 
def available?
  !@internal.empty?
end
as one of (for example)
def available? = !@internal.any?
def finished? = available? && @internal.all?(&:finished?)
def clear = @internal.clear
=end

def dbg = puts("DBG: #{caller.first}")

dbg
# Prints: DBG: test.rb:3:in `<main>'

# The method definition supports all kinds of arguments:
def dbg_args(a, b=1, c:, d: 6, &block) = puts("Args passed: #{[a, b, c, d, block.call]}")
dbg_args(0, c: 5) { 7 }
# Prints: Args passed: [0, 1, 5, 6, 7]

# For argument definition, () is mandatory
# def square x = x**2,
# syntax error, unexpected end-of-input -- because Ruby treats it as
#   def square(x = x**2)
# ...e.g. an argument with default value, referencing itself, and no method body

# This works
def square(x) = x**2
square(100) # => 10000

# To avoid confusion, defining method names like #foo= is prohibited
class A
  # SyntaxError "setter method cannot be defined in an endless method definition":
  # def attr=(val) = @attr = val

  # Other suffixes are OK:
  def attr?() = !!@attr
  def attr!() = @attr = true
end

# funnily enough, operator methods are OK, including #==
class B
  def ==(other) = true
end

p B.new == 5 # => true

# any singular expression can be method body

# This works:
def read(name) = File.read(name)
                     .split("\n")
                     .map(&:strip)
                     .reject(&:empty?)
                     .uniq
                     .sort

# Or even this, though, what's the point?..
def weird(name) = begin
                    data = File.read(name)
                    process(data)
                    true
                  rescue
                    false
                  end


=begin
inside method body, method calls without parentheses cause a syntax error:
def foo() = puts "bar"
               ^ syntax error, unexpected string literal, expecting `do' or '{' or '('

This is due to parsing ambiguity and is aligned with some other places, like
x = 1 + sin y
          ^ syntax error, unexpected tIDENTIFIER, expecting keyword_do or '{' or '('
=end

# Exercise 1: make this Ruby 3-compatible

def greet(name:)
  puts "Hello #{name}"
end

params = { name: "Amy" }

# greet(params) # fails in Ruby 3 wrong number of arguments (given 1, expected 0; required keyword: name) (ArgumentError)
# Fix: add `**` double splat operator to splat hash out into keyword args
greet(**params)


# Exercise 2: make this Ruby 3-compatible

def save_user(attributes, validate: true)
  p attributes
  p validate
end

# save_user(name: "Amy") # fails in Ruby 3 wrong number of arguments (given 0, expected 1) (ArgumentError)
# Error seems weird at first - we gave it one argument! But it's expecting a positional argument, not a named arg
# So fix is to force it to recognize the positional argument. We do this by explicitly passing a hash as the first 
# positional arg.
save_user({ name: "Amy" })

# Exercise 3: make this wrapper Ruby 3-compatible

def target(name:)
  puts name
end

def wrapper(*args, **kwargs, &block)
  target(*args, **kwargs, &block)
  puts "Called wrapper successfully"
end

wrapper(name: "Amy") # Fails in Ruby 3.0 :in 'target': wrong number of arguments (given 1, expected 0; required keyword: name) (ArgumentError)


# Exercise 4: rewrite using argument forwarding

def target(name:, greeting: "Hello")
  puts "#{greeting} #{name}"
end

def wrapper(...)
  target(...)
end

wrapper(name: "Amy")



# Back to endlesa method syntax
# Here are some examples of cdoe written in Ruby 2

# 1
def app_name
  "Job Tracker"
end

# Both of these work to define the method, but the first is more idiomatic Ruby if no args
# def app_name = puts "Job Tracker"
# def app_name() = puts "Job Tracker"

# Likewies, both of these work to call the method, but the first is more idiomatic Ruby if no args
app_name
# app_name()

# 2
# def square(x)
#   x ** 2
# end

def square(x) = x ** 2

puts square(4)

# # 3
# def full_name(first, last)
#   "#{first} #{last}"
# end

def full_name(first, last) = puts "#{first} #{last}"

full_name("Amy", "Doe")

# 4
def adult?(age)
  age >= 18
end


# Parens arouund the argument are required, but around the expression (e.g,. age >= 18) parens are optional
# Ruby prefers no parens because it's already a predicate method as indicated by `?` so parens `()` to viually
# indicate 'returns a boolean' are not necessary
def adult?(age) = age >= 18

puts adult?(18)

# # 5
# def display_name(user)
#   user[:nickname] || user[:name] || "Anonymous"
# end

def display_name(user) = user[:nickname] || user[:name] || "Anonymous"

puts display_name({noname: "Bob"}) # Prints "Anonymous"

# 6
# def total_price(price, quantity, tax_rate: 0.0)
#   price * quantity * (1 + tax_rate)
# end

def total_price(price, quantity, tax_rate: 0.0) = price * quantity * (1 + tax_rate)

puts total_price(100, 3)

# 7
# def active_admin?(user)
#   user[:active] && user[:role] == "admin"
# end

def active_admin?(user) =   user[:active] && user[:role] == "admin"

puts active_admin?({"name": "Bob", "active": true, "role": "admin"})

# 8
# def normalized_tags(tags)
#   tags.map(&:strip).reject(&:empty?).map(&:downcase).uniq.sort
# end

def normalized_tags(tags) =  tags.map(&:strip).reject(&:empty?).map(&:downcase).uniq.sort

