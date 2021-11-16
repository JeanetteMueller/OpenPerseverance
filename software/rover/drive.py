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
    
    def __init__(self):
        Thread.__init__(self)
        self.daemon = True
        self.start()

    def run(self):
        print("start run")
    def parseMessage(self,msg):
        jsonData = json.loads(msg)
        print("parse message for steer")
        
        if "drive" in jsonData:
            drive = jsonData["drive"]
            if "ml" in drive:
                if "mlc" in drive:
                    if "mr" in drive:
                        if "mrc" in drive:
                            ml = drive["ml"]
                            kit1.motor1.throttle = ml
                            kit1.motor3.throttle = ml
                            
                            mlc = drive["mlc"]
                            kit1.motor2.throttle = mlc
                            
                            mr = drive["mr"]
                            mr = mr * -1
                            kit2.motor1.throttle = mr
                            kit2.motor3.throttle = mr
                            
                            mrc = drive["mrc"]
                            mrc = mrc * -1
                            kit2.motor2.throttle = mrc
                            self.changed = 1

runner = DriveReactor()
Communicator(sock, runner)

while True:
    pass