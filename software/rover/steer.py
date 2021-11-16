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

com = Communication("steer")

sock = com.getSocket()
sock.bind((com.ip, com.getPortForSteer()))

#### Servo
pwm = Adafruit_PCA9685.PCA9685(address=0x40)
servo_min = 150.0  # Min pulse length out of 4096
servo_max = 650.0  # Max pulse length out of 4096
pwm.set_pwm_freq(60)

class SteerReactor(Thread):
    helper = Helper()
    
    steerFrontLeft  = 85
    steerFrontRight = 85
    steerBackLeft   = 85
    steerBackRight  = 85
    
    changed = 1
    
    def __init__(self):
        Thread.__init__(self)
        self.daemon = True
        self.start()

    def run(self):
        while True:
            if self.changed == 1:
                print("update steer")
                pwm.set_pwm(0, 0, int(self.helper.getPulseFromAngle(self.steerFrontLeft, servo_min, servo_max)))
                pwm.set_pwm(4, 0, int(self.helper.getPulseFromAngle(self.steerFrontRight, servo_min, servo_max)))
                pwm.set_pwm(8, 0, int(self.helper.getPulseFromAngle(self.steerBackLeft, servo_min, servo_max)))
                pwm.set_pwm(12, 0, int(self.helper.getPulseFromAngle(self.steerBackRight, servo_min, servo_max)))
                sleep(0.005)
                self.changed = 0

    def parseMessage(self,msg):
        jsonData = json.loads(msg)
        print("parse message for steer")
        
        if "steer" in jsonData:
            steer = jsonData["steer"]
            if "fl" in steer:
                if "fr" in steer:
                    if "bl" in steer:
                        if "br" in steer:
                            self.steerFrontLeft = steer["fl"]
                            self.steerFrontRight = steer["fr"]
                            self.steerBackLeft = steer["bl"]
                            self.steerBackRight = steer["br"]
                            self.changed = 1

runner = SteerReactor()
Communicator(sock, runner)

while True:
    pass
