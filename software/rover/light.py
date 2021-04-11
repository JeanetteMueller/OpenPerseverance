#!/usr/bin/env python
from __future__ import division

import socket
import json
import time
import Adafruit_PCA9685
from Communication import Communication
from Helper import Helper

com = Communication("light")

UDP_IP = com.ip
UDP_PORT = com.getPortForLight()
UDP_BUFFER = com.udpBuffer

sock = com.getSocket()
sock.bind((UDP_IP, UDP_PORT))


#### Servo
pwm = Adafruit_PCA9685.PCA9685(address=0x40)
servo_min = 150.0  # Min pulse length out of 4096
servo_max = 650.0  # Max pulse length out of 4096
pwm.set_pwm_freq(60)


def gotMessage(data):

#    i2cdetect -y
    jsonData = json.loads(data)
    
    if "light" in jsonData:
        light = jsonData["light"]
        
        if "1" in light:
            pwm.set_pwm(12, 0, int(light["1"]))
        if "2" in light:
            pwm.set_pwm(13, 0, int(light["2"]))
        if "3" in light:
            pwm.set_pwm(14, 0, int(light["3"]))
        if "4" in light:
            pwm.set_pwm(15, 0, int(light["4"]))

    
    
while True:
    data, addr = sock.recvfrom(UDP_BUFFER)
    print("received message: %s" % data)
    
    gotMessage(data)

