#!/usr/bin/env python
from __future__ import division
from threading import Thread
import sys
import socket
import json
import time
from time import sleep
from Communication import Communication
from Communicator import Communicator

from adafruit_motorkit import MotorKit
import board

com = Communication("drive")

sock = com.getSocket()
sock.bind((com.ip, com.getPortForDrive()))

kit1 = MotorKit(address=0x62)
kit2 = MotorKit(address=0x61)

class DriveReactor(Thread):
    changed = 1
    timeout = 0
    motorLeft = 0
    motorLeftCenter = 0
    
    motorRight = 0
    motorRightCenter = 0
    
    def __init__(self):
        Thread.__init__(self)
        self.daemon = True
        self.start()

    def run(self):
        print("start run")
        while True:
            if self.timeout > 0:
                self.timeout = self.timeout - 1

            if self.timeout <= 0:
                self.motorLeft = 0
                self.motorLeftCenter = 0
                self.motorRight = 0
                self.motorRightCenter = 0
                print("-------------- FULL STOP -------------")

            kit1.motor1.throttle = self.motorLeft
            kit1.motor3.throttle = self.motorLeft
            kit1.motor2.throttle = self.motorLeftCenter
            kit2.motor1.throttle = self.motorRight
            kit2.motor3.throttle = self.motorRight
            kit2.motor2.throttle = self.motorRightCenter
            print("set new motor values " + str(self.timeout))
            sleep(0.02)
            
    def newTimeout(self):
        self.timeout = 10
        print("--------------------set new timeout ")
    def parseMessage(self,msg):
        jsonData = json.loads(msg)
        print("parse message for drive " + str(msg))
        
        if "drive" in jsonData:
            drive = jsonData["drive"]

            self.newTimeout()
            if "ml" in drive:
                if "mlc" in drive:
                    if "mr" in drive:
                        if "mrc" in drive:
                            self.motorLeft = drive["ml"]
                            self.motorLeftCenter = drive["mlc"]
                            self.motorRight = drive["mr"] * -1
                            self.motorRightCenter = drive["mrc"] * -1
                            

runner = DriveReactor()
Communicator(sock, runner)

while True:
    #print("main while loop")
    pass

