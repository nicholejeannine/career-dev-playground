def speak_yield
    # this argument gets passed to the block
    yield("World")
end

#$speak_yield { |name| puts "#{name} from speak_yield"}

def speak_yield_with_arg(name)
    yield(name)
end

# This will throw an ArgumentError because the method expects a single arg as well as a block
# speak_yield_with_arg  { |name| puts "#{name} from speak_yield"}
# So call it like this
speak_yield_with_arg("Fred") { |name| puts "#{name} was passed as an arg"}

# We can pass as many args to yield as we want, for use in sah
# each_with_index

def number_evaluation(num1, num2, num3)
    yield(num1, num2, num3)
end

# 3 sequential variables passed with the block
# This will allow the block to run; we give it all 3 arguments;
# because we have an implicit return at the end that's what is printed
# Basically the final evaluation of the method call returns the successive calls of the method with each arg
p number_evaluation(5, 10, 15) { |a, b, c| a + b + c }

# Another example
p number_evaluation(3, 4, 5) { |a, b, c| a * b * c }
