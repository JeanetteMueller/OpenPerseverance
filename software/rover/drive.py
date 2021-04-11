#!/usr/bin/env python
from __future__ import division

import socket
import json
import time
from time import sleep
import PCA9685
from MotorDriver import MotorDriver
from Communication import Communication
from Helper import Helper

com = Communication("drive")

sock = com.getSocket()
sock.bind((com.ip, com.getPortForDrive()))


#Vorder Rader
motorController1 = PCA9685.PCA9685(0x41, debug=False)
motorController1.setPWMFreq(60)
#Center Rader
motorController2 = PCA9685.PCA9685(0x42, debug=False)
motorController2.setPWMFreq(60)
#Hinter Rader
motorController3 = PCA9685.PCA9685(0x44, debug=False)
motorController3.setPWMFreq(60)


Motor = MotorDriver()


def gotMessage(data):

#    i2cdetect -y
    jsonData = json.loads(data)
    
    if "drive" in jsonData:
        drive = jsonData["drive"]
        if "ml" in drive:
            ml = drive["ml"]

            if ml > 0:
                Motor.MotorRun(motorController1, 0,'forward', ml)
                Motor.MotorRun(motorController3, 0,'forward', ml)
            elif ml < 0:
                ml = ml * -1
                Motor.MotorRun(motorController1, 0, 'backward', ml)
                Motor.MotorRun(motorController3, 0, 'backward', ml)
            else:
                Motor.MotorStop(motorController1, 0)
                Motor.MotorStop(motorController3, 0)

        if "mlc" in drive:
            mlc = drive["mlc"]
            print("motor left center")

            if mlc > 0:
                Motor.MotorRun(motorController2, 0,'forward', mlc)
            elif mlc < 0:
                Motor.MotorRun(motorController2, 0, 'backward', mlc * -1)
            else:
                Motor.MotorStop(motorController2, 0)
        

        if "mr" in drive:
            mr = drive["mr"]

            if mr > 0:
                Motor.MotorRun(motorController1, 1,'backward', mr)
                Motor.MotorRun(motorController3, 1,'backward', mr)
            elif mr < 0:
                mr = mr * -1
                Motor.MotorRun(motorController1, 1, 'forward', mr)
                Motor.MotorRun(motorController3, 1, 'forward', mr)
            else:
                print("stop")
                Motor.MotorStop(motorController1, 1)
                Motor.MotorStop(motorController3, 1)


        if "mrc" in drive:
            mrc = drive["mrc"]

            if mrc > 0:
                Motor.MotorRun(motorController2, 1,'backward', mrc)
            elif mrc < 0:
                Motor.MotorRun(motorController2, 1, 'forward', mrc * -1)
            else:
                Motor.MotorStop(motorController2, 1)

    
while True:
    data, addr = sock.recvfrom(com.udpBuffer)
    print("received message drive: %s" % data)
    
    gotMessage(data)
    
    #sleep(0.01)