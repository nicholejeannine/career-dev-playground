puts "Using Ruby version #{RUBY_VERSION}"

def greet(name:)
  puts "Hello #{name}"
end

def wrapper(*args)
  greet(*args)
end

wrapper(name: "Amy")