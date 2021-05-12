#!/usr/bin/env python
from __future__ import division

import socket
import json
import time
import os

from Communication import Communication
from Helper import Helper

com = Communication("sound")

sock = com.getSocket()
# sock.bind((com.ip, com.getPortForSound()))


def gotMessage(data):

#    i2cdetect -y
    jsonData = json.loads(data)
    
    if "sound" in jsonData:
        sound = jsonData["sound"]
        
        if "file" in sound:
            fileName = sound["file"]
            
            f = "omxplayer '/home/pi/sounds/" + fileName + "' &"
            
            print(f)
        
            os.system(f)

        if "action" in sound:
            action = sound["action"]
        

def loop():
    fileName = "Directive.mp3"
    f = "omxplayer '/home/pi/sounds/" + fileName + "' &"
    
    print(f)

    os.system(f)
    
    while True:
        data, addr = sock.recvfrom(com.udpBuffer)
        print("received message: %s" % data)
    
        gotMessage(data)
    
def destroy():
    print("Exiting")
        
if __name__ == '__main__': # Program start from here 
    try: 
        loop()
    except KeyboardInterrupt: 
        # When 'Ctrl+C' is pressed, the child program destroy() will be executed.
        destroy()