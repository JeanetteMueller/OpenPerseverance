#!/usr/bin/env python
from __future__ import division

import socket
import json
import time

from Communication import Communication

com = Communication("power")

UDP_IP = com.ip
UDP_PORT = com.getPortForPower()
UDP_BUFFER = com.udpBuffer

sock = com.getSocket()
sock.bind((UDP_IP, UDP_PORT))


def gotMessage(data, addr):

#    i2cdetect -y
    jsonData = json.loads(data)
    
    if "power" in jsonData:
        power = jsonData["power"]
        
        if "get" in power:
            
            answer = {"get": "Das hier ist meine Antwort"}
            
            print("send message: %s" % answer["get"])
            
            message = json.dumps(answer)
            
            sock.sendto(message, addr)

    
    
while True:
    data, addr = sock.recvfrom(UDP_BUFFER)
    print("received message: %s" % data)
    
    gotMessage(data, addr)

