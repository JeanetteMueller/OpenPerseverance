#!/usr/bin/env python
from __future__ import division

import socket
import json
import time

import Adafruit_PCA9685
from Communication import Communication
from Helper import Helper

com = Communication("tower")

sock = com.getSocket()
sock.bind((com.ip, com.getPortForTower()))

#### Servo
pwm = Adafruit_PCA9685.PCA9685(address=0x58)
servo_min = 50.0  # Min pulse length out of 4096
servo_max = 650.0  # Max pulse length out of 4096
pwm.set_pwm_freq(60)


## PULSE NUR AN SEPARATEM PWM BOARD ANDERN
#
# pwm = Adafruit_PCA9685.PCA9685(address=0x58)
# servo_min = 0  # Min pulse length out of 4096
# servo_max = 4096  # Max pulse length out of 4096
# pwm.set_pwm_freq(50)


def gotMessage(data):

    jsonData = json.loads(data)
    
    if "tower" in jsonData:
        tower = jsonData["tower"]
        helper = Helper()
        
        if "rotation" in tower:
            print("got message: rotation")
            pwm.set_pwm(0, 0, int(helper.getPulseFromAngle(tower["rotation"], servo_min, servo_max)))
        if "tilt" in tower:
            print("got message: tilt")
            pwm.set_pwm(1, 0, int(helper.getPulseFromAngle(tower["tilt"], servo_min, servo_max)))
    
    
while True:
    data, addr = sock.recvfrom(com.udpBuffer)
    print("received message: %s" % data)
    
    gotMessage(data)

