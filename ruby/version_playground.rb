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