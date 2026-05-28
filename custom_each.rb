# Ruby's built-in each method
# [10, 20, 30].each { |num| puts "The square of the number is #{num * num}"}

# I want to do like this
# custom_each([10, 20, 30]) { |num| puts "I have the square #{num * num)}"}

def custom_each(elements)
    i = 0
    while i < elements.length
        yield elements[i] # Or yield(elements[i]) notation
        i += 1
    end
end

custom_each([10, 20, 30]) { |num| puts "I have the square #{num * num}"}

# So anythuing we want to do over and over (like on an array), we can define a custom method for with a block etc
