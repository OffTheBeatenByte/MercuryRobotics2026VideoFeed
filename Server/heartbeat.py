"""heartbeat.py

This program has two roles:
1. Receive the IP address of the client from that client
2. Maintain the heartbeat connection (a 1-character udp packet of port 9999)

This heartbeat ping tells the robot that the client is still alive and 
connected.  heartbeat.py will know within 1/4 of a second if the client has disconnected,
and this program notifies the rest of the robot to shutdown.
"""


import socket
import time
import sys
import os
import select

IP_LOCATION = "./IP"

def single_connection(sock, ip):
    # save IP address
    print(f"Received IP address: {ip}")
    with open(IP_LOCATION, "w") as f:
        f.write(str(ip).strip())
    
    # start systemd commands
    os.system("sudo systemctl start camera0send.service")
    os.system("sudo systemctl start camera1send.service")
    os.system("sudo systemctl start camera2send.service")
    
    # receive heartbeat
    sock.settimeout(0.25) # we need a heartbeat at least every quarter second, so there is time to shut down the motors within 1 second if there is a loss of signal
    while True:
        try:
            sock.recv(2)
        except socket.timeout:
            # we've lost connection
            break
    
    # stop systemd
    os.system("sudo systemctl stop camera0send.service")
    os.system("sudo systemctl stop camera1send.service")
    os.system("sudo systemctl stop camera2send.service")
    
    return


def main():
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.settimeout(1/60)
    sock.bind(('', 9999))
    while True:
        # wait for connection
        while True:
            try:
                ip = sock.recv(17)
                break
            except socket.timeout:
                pass
        # process this connection
        single_connection(sock, ip)

if __name__ == "__main__":
    main()