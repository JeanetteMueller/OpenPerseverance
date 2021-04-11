#!/usr/bin/env python
from __future__ import division

import socket
import json
import time
import PCA9685
import Adafruit_PCA9685
from MotorDriver import MotorDriver

from Communication import Communication
from Helper import Helper

com = Communication("sound")

UDP_IP = com.ip
UDP_PORT = com.getPortForSound()
UDP_BUFFER = com.udpBuffer

sock = com.getSocket()
sock.bind((UDP_IP, UDP_PORT))


def gotMessage(data):

#    i2cdetect -y
    jsonData = json.loads(data)
    
    if "sound" in jsonData:
        sound = jsonData["sound"]
        
    
    
while True:
    data, addr = sock.recvfrom(UDP_BUFFER)
    print("received message: %s" % data)
    
    gotMessage(data)

