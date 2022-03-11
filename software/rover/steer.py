#!/usr/bin/env python
from __future__ import division

from threading import Thread
import sys
import socket
import json
import time
import math
from time import sleep

# from PCA9685 import PCA9685
from Adafruit_PCA9685 import PCA9685

from Communication import Communication
from Communicator import Communicator
from Helper import Helper

com = Communication("steer")

sock = com.getSocket()
sock.bind((com.ip, com.getPortForSteer()))

#### Servo
pwm = PCA9685(address=0x40)
servo_min = 150.0  # Min pulse length out of 4096
servo_max = 650.0  # Max pulse length out of 4096
pwm.set_pwm_freq(50)

class SteerReactor(Thread):
    helper = Helper()
    
    lastSteerChange = 0
    lastArmChange = 0
    
    steerFrontLeft  = 85
    steerFrontRight = 85
    steerBackLeft   = 85
    steerBackRight  = 85
    
    steerChanged = 0
    
    armJoint1 = 85
    armJoint2 = 85
    armJoint3 = 85
    armJoint4 = 85
    
    armChanged = 0
    
    def __init__(self):
        Thread.__init__(self)
        self.daemon = True
        self.start()

    def run(self):
        while True:
            if self.steerChanged == 1:
                pwm.set_pwm(0, 0, int(self.helper.getPulseFromAngle(self.steerFrontLeft, servo_min, servo_max)))
                pwm.set_pwm(1, 0, int(self.helper.getPulseFromAngle(self.steerFrontRight, servo_min, servo_max)))
                pwm.set_pwm(2, 0, int(self.helper.getPulseFromAngle(self.steerBackLeft, servo_min, servo_max)))
                pwm.set_pwm(3, 0, int(self.helper.getPulseFromAngle(self.steerBackRight, servo_min, servo_max)))
                self.steerChanged = 0
                
            if self.armChanged == 1:
                pwm.set_pwm(12, 0, int(self.helper.getPulseFromAngle(self.armJoint1, 150, 650)))
                self.armChanged = 0
            
            sleep(0.001)

    def parseMessage(self,msg):
        jsonData = json.loads(msg)
        
        if "steer" in jsonData:
            steer = jsonData["steer"]
            if "time" in steer:
                if steer["time"] > self.lastSteerChange:
                    if "fl" in steer:
                        if "fr" in steer:
                            if "bl" in steer:
                                if "br" in steer:
                                    print("set new steer data " + str(msg))
                                    self.steerFrontLeft = steer["fl"]
                                    self.steerFrontRight = steer["fr"]
                                    self.steerBackLeft = steer["bl"]
                                    self.steerBackRight = steer["br"]
                                    self.lastSteerChange = steer["time"]
                                    self.steerChanged = 1
        if "arm" in jsonData:
            arm = jsonData["arm"]
            if "time" in arm:
                if arm["time"] > self.lastArmChange:
                    if "j1" in arm:
                        if "j2" in arm:
                            if "j3" in arm:
                                if "j4" in arm:
                                    self.armJoint1 = arm["j1"]
                                    self.armJoint2 = arm["j2"]
                                    self.armJoint3 = arm["j3"]
                                    self.armJoint4 = arm["j4"]
                                    self.lastArmChange = arm["time"]
                                    self.armChanged = 1
                            
                            

runner = SteerReactor()
Communicator(sock, runner)

while True:
    pass
