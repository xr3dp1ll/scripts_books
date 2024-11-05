import requests
import json

# Login information
url = "https://example.com/login"  # URL of the login API
data = {
    'username': 'myuser',  # Username for login
    'password': 'mypassword'  # Password for login
}

# Send the data as JSON in the POST request
response = requests.post(url, json=data)

# Check the status code of the response
if response.status_code == 200:
    print("Login successful")  # If the status code is 200, login is successful
else:
    print("Login failed", response.status_code)  # If status code is not 200, login failed
