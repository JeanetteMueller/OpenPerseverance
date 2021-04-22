#!/usr/bin/env python
from __future__ import division

import socket
import json
import time
import Adafruit_PCA9685
from Communication import Communication
from Helper import Helper

com = Communication("tower")

UDP_IP = com.ip
UDP_PORT = com.getPortForTower()
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
    

    if "tower" in jsonData:
        tower = jsonData["tower"]
        
        helper = Helper()
        
        if "position" in tower:
            pwm.set_pwm(8, 0, int(helper.getPulseFromAngle(tower["position"], servo_min, servo_max)))
        if "rotation" in tower:                  
            pwm.set_pwm(9, 0, int(helper.getPulseFromAngle(tower["rotation"], servo_min, servo_max)))
        if "tilt" in tower:                  
            pwm.set_pwm(10, 0, int(helper.getPulseFromAngle(tower["tilt"], servo_min, servo_max)))
    
    
while True:
    data, addr = sock.recvfrom(UDP_BUFFER)
    print("received message: %s" % data)
    
    gotMessage(data)

