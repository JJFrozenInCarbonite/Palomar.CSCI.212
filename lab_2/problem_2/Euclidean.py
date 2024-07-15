def gcd(a, b):
    while b != 0:
        a, b = b, a % b
    return a

# Get input from the user
term1 = int(input("Enter the first number: "))
term2 = int(input("Enter the second number: "))

# Calculate the GCD
result = gcd(term1, term2)

# Print the result
print("The Greatest Common Divisor is:", result)