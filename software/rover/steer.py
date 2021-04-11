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

com = Communication("steer")

sock = com.getSocket()
sock.bind((com.ip, com.getPortForSteer()))


#### Servo
pwm = Adafruit_PCA9685.PCA9685(address=0x40)
servo_min = 150.0  # Min pulse length out of 4096
servo_max = 650.0  # Max pulse length out of 4096
pwm.set_pwm_freq(60)


def gotMessage(data):

#    i2cdetect -y
    jsonData = json.loads(data)
    
    if "steer" in jsonData:
        steer = jsonData["steer"]
        
        helper = Helper()
        
        if "fl" in steer:
            pwm.set_pwm(0, 0, int(helper.getPulseFromAngle(steer["fl"], servo_min, servo_max)))
        if "fr" in steer:
            pwm.set_pwm(1, 0, int(helper.getPulseFromAngle(steer["fr"], servo_min, servo_max)))
        if "bl" in steer:
            pwm.set_pwm(2, 0, int(helper.getPulseFromAngle(steer["bl"], servo_min, servo_max)))
        if "br" in steer:
            pwm.set_pwm(3, 0, int(helper.getPulseFromAngle(steer["br"], servo_min, servo_max)))
    

maxRange = 170.0
lastPos = 170.0

steps = 30

def oneCycle(targetDegree, fromDegree):
    print("oneCycle")
    
    global lastPos
    
    #differenz = fromDegree + targetDegree
    
    if targetDegree > fromDegree:
        
        target = targetDegree - fromDegree
    elif targetDegree < fromDegree:
        print("targetDegree < fromDegree")
        
        target = 0.0

        #pwm.set_pwm(4, 0, int(helper.getPulseFromAngle(pos, servo_min, servo_max)))
    else:
        print("ich mach hier mal nix")  
        
        return
        
    
    helper = Helper()
    
    for step in range(0,steps + 1):
        
        wert = float(step) / float(steps / 2)
        
        teil = wert * (math.pi / 2) + (math.pi / 2)
        
        #teil = math.sin(float(step) / (float(steps) / float(2)) ) * math.pi 
        
        position = (math.sin(teil) + 1.0) / 2
        
        pos = position * (target / 2.0) + (target / 2.0) + fromDegree
        
        print("step %f   fromDegree %f   position %f   pos %f" % (step, fromDegree, position, pos))
        
        pwm.set_pwm(4, 0, int(helper.getPulseFromAngle(pos, servo_min, servo_max)))
        
        #position = teil * target
        
        #print("set servo step %f position %f" % (step, position))
        
        
        
        if step == steps:
            lastPos = pos
        
        sleep(0.08)
        
    
    
    

    #for degrees in range(0, 180):
  
        # radians = (degrees * math.pi) / 180.0
        
        #for servo in range(4, 5):
    
            # Map the sin() function to the servomin..servomax range
            
        #position = (math.sin(radians) + 1.0) * ((servo_max - servo_min) / 2.0) + servo_min
         
        #position = helper.getPulseFromAngle(degrees, servo_min, servo_max)
           
        #pwm.set_pwm(4, 0, int(position))
            # radians += (2.0 * math.pi) / (16.0 * 4);  # Advance 1/16th of a circle
    
        #sleep(0.1)  #  3600 milliseconds per cycle

while True:
    data, addr = sock.recvfrom(com.udpBuffer)
    print("received message: %s" % data)

    gotMessage(data)
    
    # oneCycle(170, lastPos)
    # sleep(1)
    #
    # oneCycle(0, lastPos)
    # sleep(1)
    # sleep(0.01)