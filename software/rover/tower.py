#!/usr/bin/env python
from __future__ import division

from threading import Thread
import sys
import socket
import json
import time
import math
from time import sleep

import Adafruit_PCA9685
from Communication import Communication
from Communicator import Communicator
from Helper import Helper

com = Communication("tower")

sock = com.getSocket()
sock.bind((com.ip, com.getPortForTower()))

#### Servo
pwm = Adafruit_PCA9685.PCA9685(address=0x58)
servo_min = 50.0  # Min pulse length out of 4096
servo_max = 650.0  # Max pulse length out of 4096
pwm.set_pwm_freq(60)

class TowerReactor(Thread):
    helper = Helper()
    
    towerRotation = 85
    towerTilt = 0
    
    istTilt = 65
    
    antenna = 30
    antennaStep = 0.8
    antennaMovement = 0
    antennaWait = 0
    antennaWaitTime = 100
    antennaMin = 30
    antennaMax = 170
    
    def __init__(self):
        Thread.__init__(self)
        self.daemon = True
        self.start()
    def run(self):
        while True:
            #Tower Rotation
            pwm.set_pwm(0, 0, int(self.helper.getPulseFromAngle(self.towerRotation, servo_min, servo_max)))
        
            #Tower Tilt
            newTiltValue = self.istTilt + ( self.towerTilt * 2)
            if newTiltValue > 130:
                newTiltValue = 130
            if newTiltValue < 30:
                newTiltValue = 30
            pwm.set_pwm(1, 0, int(self.helper.getPulseFromAngle(newTiltValue, servo_min, servo_max)))
            self.istTilt = newTiltValue
            
            
            if self.antennaWait > 0:
                self.antennaWait = self.antennaWait - 1
                print("antenna sleep: " + str(self.antennaWait))
            else:
                
                if self.antennaMovement == 0:
                    self.antenna = self.antenna + self.antennaStep
                else:
                    self.antenna = self.antenna - self.antennaStep
                
                if self.antenna > self.antennaMax:
                    self.antennaMovement = 1
                    self.antennaWait = self.antennaWaitTime
                elif self.antenna < self.antennaMin:
                    self.antennaMovement = 0
                    self.antennaWait = self.antennaWaitTime
                pwm.set_pwm(4, 0, int(self.helper.getPulseFromAngle(self.antenna, servo_min, servo_max)))
                print("antenna rotate: " + str(self.antenna))
            
            sleep(0.02)

    def parseMessage(self,msg):
        jsonData = json.loads(msg)
        print("parse message for tower")
        if "tower" in jsonData:
            tower = jsonData["tower"]
            if "r" in tower:
                if "t" in tower:
                    print("message")
                    self.towerRotation = tower["r"]
                    self.towerTilt = tower["t"]

runner = TowerReactor()
Communicator(sock, runner)

while True:
    pass
