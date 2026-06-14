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
new_style('John', **{age: 10})

# Ruby 2.6: works
# Ruby 2.7: warns: Using the last argument as keyword parameters is deprecated; maybe ** should be added to the call
# Ruby 3.0: ArgumentError (wrong number of arguments (given 2, expected 1))
new_style('John', age: 10)
# => works
h = {age: 10}
new_style('John', **h)
# => works, ** is mandatory

# The last hash argument still allowed to be passed without {}:
old_style('John', age: 10)
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

