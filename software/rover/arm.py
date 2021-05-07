#!/usr/bin/env python
from __future__ import division

import socket
import json
import time
import math
from time import sleep
import Adafruit_PCA9685
from Communication import Communication
from Helper import Helper

com = Communication("arm")

sock = com.getSocket()
sock.bind((com.ip, com.getPortForArm()))

#### Servo
pwm = Adafruit_PCA9685.PCA9685(address=0x40)
servo_min = 150.0  # Min pulse length out of 4096
servo_max = 650.0  # Max pulse length out of 4096
pwm.set_pwm_freq(60)


def gotMessage(data):

    jsonData = json.loads(data)
    
    if "arm" in jsonData:
        arm = jsonData["arm"]
        
        helper = Helper()
        
        if "1" in arm:
            pwm.set_pwm(4, 0, int(helper.getPulseFromAngle(arm["1"], servo_min, servo_max)))
        if "2" in arm:                  
            pwm.set_pwm(5, 0, int(helper.getPulseFromAngle(arm["2"], servo_min, servo_max)))
        if "3" in arm:                  
            pwm.set_pwm(6, 0, int(helper.getPulseFromAngle(arm["3"], servo_min, servo_max)))
        if "4" in arm:                  
            pwm.set_pwm(7, 0, int(helper.getPulseFromAngle(arm["4"], servo_min, servo_max)))
    
    
while True:
    data, addr = sock.recvfrom(com.udpBuffer)
    print("received message: %s" % data)
    
    gotMessage(data)
