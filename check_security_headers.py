import requests
import argparse
from colorama import init, Fore, Back, Style

# Initialize colorama to enable colored text output in the console
init(autoreset=True)

def check_security_headers(url):
    try:
        # Send an HTTP GET request to the given URL with a timeout of 10 seconds
        response = requests.get(url, timeout=10)

        # Check if the HTTP response status code is not 200 (OK)
        if response.status_code != 200:
            print(Fore.YELLOW + f"Warning: {url} returned status code {response.status_code}")
            return

        # Extract the headers from the HTTP response
        headers = response.headers

        # List of security-related headers to check for
        security_headers = [
            'Strict-Transport-Security', 
            'X-Content-Type-Options', 
            'X-Frame-Options', 
            'X-XSS-Protection', 
            'Content-Security-Policy', 
            'Referrer-Policy', 
            'Permissions-Policy',
            'X-Permitted-Cross-Domain-Policies',
            'Cache-Control',
            'Access-Control-Allow-Origin',
            'Set-Cookie'
        ]

        # Print the security headers found for the URL
        print(Fore.CYAN + f"Security headers for {url} (Status Code: {response.status_code}):\n")

        # Loop through the security headers and check if they are present in the response
        for header in security_headers:
            if header in headers:
                print(Fore.GREEN + f"[+] {header}: {headers[header]}")  # Green for present headers
            else:
                print(Fore.RED + f"[-] {header}: Not present")  # Red for missing headers

        # Check if the site is using HTTPS
        if url.startswith("https://"):
            print(Fore.GREEN + "[+] HTTPS is used")
        else:
            print(Fore.RED + "[-] HTTPS is not used. The connection is insecure!")

        # Check for Content-Security-Policy (CSP) header
        if 'Content-Security-Policy' in headers:
            csp = headers['Content-Security-Policy']
            print(Fore.GREEN + f"[+] Content-Security-Policy: {csp}")
            # Check if 'default-src' is defined in the CSP
            if "default-src" not in csp:
                print(Fore.YELLOW + "[-] Content-Security-Policy does not define 'default-src'. This could be a security concern.")
        else:
            print(Fore.RED + "[-] Content-Security-Policy header is not set.")

        # Check for Strict-Transport-Security (HSTS) header
        if 'Strict-Transport-Security' in headers:
            hsts = headers['Strict-Transport-Security']
            print(Fore.GREEN + f"[+] Strict-Transport-Security: {hsts}")
        else:
            print(Fore.RED + "[-] Strict-Transport-Security (HSTS) is not set.")

        # Check if cookies are marked as Secure and HttpOnly
        if 'Set-Cookie' in headers:
            cookies = headers['Set-Cookie']
            if "Secure" not in cookies:
                print(Fore.YELLOW + "[-] Cookies are not marked as Secure. This is a potential security risk.")
            if "HttpOnly" not in cookies:
                print(Fore.YELLOW + "[-] Cookies are not marked as HttpOnly. This could allow client-side scripts to access cookies.")

    # Handle different exceptions that can occur during the request
    except requests.exceptions.Timeout:
        print(Fore.RED + "[-] Request timed out. The server might be too slow or down.")
    except requests.exceptions.ConnectionError:
        print(Fore.RED + "[-] Could not establish a connection to the server.")
    except requests.exceptions.HTTPError as err:
        print(Fore.RED + f"[-] HTTP error occurred: {err}")
    except Exception as e:
        print(Fore.RED + f"[-] An unexpected error occurred: {e}")

# Function to handle command line arguments
def main():
    # Create an argument parser for accepting the URL as an argument
    parser = argparse.ArgumentParser(description="Check security headers of a URL")
    parser.add_argument("url", type=str, help="The URL to check security headers for")
    
    # Parse the arguments provided by the user
    args = parser.parse_args()
    
    # Call the function to check the security headers for the provided URL
    check_security_headers(args.url)

# Execute the main function if the script is run directly
if __name__ == "__main__":
    main()
