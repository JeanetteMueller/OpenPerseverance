#!/usr/bin/env python
from __future__ import division

import socket
import json
import time

from Communication import Communication

com = Communication("info")

sock = com.getSocket()
sock.bind((com.ip, com.getPortForInfo()))

def gotMessage(data, addr):

    jsonData = json.loads(data)
    
    if "info" in jsonData:
        info = jsonData["info"]
        if "get" in info:
            answer = {"get": "Das hier ist meine Antwort"}
            print("send message: %s" % answer["get"])
            message = json.dumps(answer)
            sock.sendto(message, addr)

while True:
    data, addr = sock.recvfrom(com.udpBuffer)
    print("received message: %s" % data)
    
    gotMessage(data, addr)

