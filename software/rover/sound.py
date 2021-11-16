#!/usr/bin/env python
from __future__ import division

from threading import Thread
import sys
import socket
import json
import time
import math
import os
from time import sleep

from Communication import Communication
from Communicator import Communicator
from Helper import Helper

com = Communication("sound")

sock = com.getSocket()
sock.bind((com.ip, com.getPortForSound()))

class SoundReactor(Thread):
    helper = Helper()
    
    filename = "Robot - Identification please.mp3"
    changed = 1
    
    def __init__(self):
        Thread.__init__(self)
        self.daemon = True
        self.start()

    def run(self):
        while True:
            if self.changed == 1:
                f = "mpg321 '/home/pi/sounds/" + self.filename + "' -g 100"
                print(f)
                os.system(f)
                self.changed = 0

    def parseMessage(self,msg):
        jsonData = json.loads(msg)
        print("parse message for sound")
        if "sound" in jsonData:
            sound = jsonData["sound"]
        
            print("got sound")
        
            if "file" in sound:
                self.filename = sound["file"]
                self.changed = 1

runner = SoundReactor()
Communicator(sock, runner)

while True:
    pass
