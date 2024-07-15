term = int(input('Enter the term: '))
a = 1
b = 1
for i in range(1, term - 1):
    c = a + b
    a = b
    b = c
print(c)