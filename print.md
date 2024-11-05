## Here are comments for each line of your code, explaining what each part does:

```python
# Define a variable 'name' with the value "Alice"
name = "Alice"
# Define a variable 'age' with the value 25
age = 25
# OUTPUT1: Print formatted string using .format() method to insert variables 'name' and 'age' into the string
print("OUTPUT1: Name: {}, Age: {}".format(name, age))
```
#### output:
```
OUTPUT1: Name: Alice, Age: 25
```
---

```python
# OUTPUT2: Print formatted string using f-string (formatted string literals) to insert variables 'name' and 'age' into the string
print(f"OUTPUT2: Name: {name}, Age: {age}")
```
#### output:
```
OUTPUT2: Name: Alice, Age: 25
```


```python
# Define a variable 'pi' with the value of Pi (approximate)
pi = 3.14159
# OUTPUT3: Print the value of 'pi' rounded to 2 decimal places using f-string formatting
print(f"OUTPUT3: Value of Pi to 2 decimal places: {pi:.2f}")
```
```python
# OUTPUT4: Print "Hello-World" using a hyphen as the separator between the two strings
print("OUTPUT4: Hello", "World", sep="-")
```
```python
# OUTPUT5: Print a multi-line string using triple quotes, which preserves line breaks
print("""OUTPUT5:
This is a multi-line
string in Python.
You can write multiple lines.
""")
```
```python
# OUTPUT6: Print "Hello" followed by a space and then "World" without a newline between them
print("OUTPUT6: Hello", end=" ")
print("World")
```
```python
# OUTPUT7: Simple print statement showing a string "Hello, World!"
print("OUTPUT6: Hello, World!")
```
