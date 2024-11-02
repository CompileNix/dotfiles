#!python3
import socket
import sys

Color_Reset='\033[0m'
Green='\033[0;32m'
Yellow='\033[0;33m'
Purple='\033[0;35m'
Bold_Blue='\033[1;34m'
Blue='\033[0;34m'
Underline_White='\033[4;37m'

def main():
    if len(sys.argv) != 6:
        print(f"Usage: {Green}send_email.py{Color_Reset} {Yellow}ip_of_smtp_server{Color_Reset} {Purple}port_of_smtp_server{Color_Reset} {Bold_Blue}from_address{Color_Reset} {Bold_Blue}to_address{Color_Reset} {Blue}subject{Color_Reset} < {Underline_White}body.txt{Color_Reset}")
        sys.exit(1)

    ip_of_smtp_server = sys.argv[1]
    port_of_smtp_server = int(sys.argv[2])
    from_address = sys.argv[3]
    to_address = sys.argv[4]
    subject = sys.argv[5]

    print("Read email body from stdin")
    body = sys.stdin.read()

    print("Create the email message")
    message = f"From: {from_address}\r\nTo: {to_address}\r\nSubject: {subject}\r\n\r\n{body}\r\n"

    try:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            print(f"Connect to {ip_of_smtp_server}:{port_of_smtp_server} ...")
            s.connect((ip_of_smtp_server, port_of_smtp_server))
            print(f"Connected!")

            recv = s.recv(1024).decode()
            print(f"R: {recv.strip()}")

            msg="EHLO example.com"
            print(f"S: {msg}")
            s.sendall(f"{msg}\r\n".encode())
            recv = s.recv(1024).decode()
            print(f"R: {recv.strip()}")

            msg=f"MAIL FROM:<{from_address}>"
            print(f"S: {msg}")
            s.sendall(f"{msg}\r\n".encode())
            recv = s.recv(1024).decode()
            print(f"R: {recv.strip()}")

            msg=f"RCPT TO:<{to_address}>"
            print(f"S: {msg}")
            s.sendall(f"{msg}\r\n".encode())
            recv = s.recv(1024).decode()
            print(f"R: {recv.strip()}")

            msg="DATA"
            print(f"S: {msg}")
            s.sendall(f"{msg}\r\n".encode())
            recv = s.recv(1024).decode()
            print(f"R: {recv.strip()}")

            msg=f"{message}"
            print(f"S: \n{msg}")
            s.sendall(f"{msg}\r\n.\r\n".encode())
            recv = s.recv(1024).decode()
            print(f"R: {recv.strip()}")

            msg="QUIT"
            print(f"S: {msg}")
            s.sendall(f"{msg}\r\n".encode())
            recv = s.recv(1024).decode()
            print(f"R: {recv.strip()}")

    except socket.error as e:
        print(f"Socket error: {e}")
        sys.exit(1)
    print("Disconnected")

if __name__ == "__main__":
    main()
