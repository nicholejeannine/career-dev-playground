# Python comments
'''Multiline comments
can be written thusly'''

# assign multiple vars at once
a, b, c = 5, 3.2, 'Hello'

# define complex numbers, e.g., with imaginary number `i` (designated as `j` in Python)

a = 9 + 3j
b = 3 + 4j
print(a + b) # prints (12 + 7j)

# Boolean literal are written with Titlecase
is_pass = True
print(is_pass) # Prints True

# Null is a special literal 'None'
value = None

print(value) # Output: None

# ranges - use range() function. Note - range starts at 0 if beginning not specified
# for i in range(5):
    # print(i) # prints 0 through 4

for i in range(1, 5): # the given endpoint is STILL not part of the sequenece
    print(i) # Prints 1 through 4
for i in range(0, 100, 9): # optional step param
    print(i)