#!/usr/bin/env python
from __future__ import division

import socket
import json
import time

import RPi.GPIO as GPIO

from Communication import Communication

com = Communication("light")

sock = com.getSocket()
sock.bind((com.ip, com.getPortForLight()))

ledPin_red = 23
ledPin_green = 24
ledPin_blue = 25

def setup():
    GPIO.setmode(GPIO.BCM) #BOARD
    GPIO.setup(ledPin_red, GPIO.OUT, initial=GPIO.HIGH)
    # GPIO.output(ledPin_red, GPIO.LOW) # Set ledPin low to off led

    GPIO.setup(ledPin_green, GPIO.OUT, initial=GPIO.HIGH)
    # GPIO.output(ledPin_green, GPIO.LOW)

    GPIO.setup(ledPin_blue, GPIO.OUT, initial=GPIO.HIGH)
    # GPIO.output(ledPin_blue, GPIO.LOW)

red = 0
green = 0
blue = 0

def gotMessage(data):

#    i2cdetect -y
    jsonData = json.loads(data)
    
    if "head" in jsonData:
        head = jsonData["head"]
        
        if "r" in head:
            red = int(head["r"])
        if "g" in head:
            green = int(head["g"])
        if "b" in head:
            blue = int(head["b"])
            
        if red == 1:
            GPIO.output(ledPin_red, GPIO.LOW)
        else: 
            GPIO.output(ledPin_red, GPIO.HIGH)
            
        if green == 1: 
            GPIO.output(ledPin_green, GPIO.LOW)
        else: 
            GPIO.output(ledPin_green, GPIO.HIGH)
            
        if blue == 1: 
            GPIO.output(ledPin_blue, GPIO.LOW)
        else:
            GPIO.output(ledPin_blue, GPIO.HIGH)   
            
def loop():
    print ('main loop')
#     while (True):
#         GPIO.output(ledPin_red, GPIO.LOW) # led on
#         print ('led on red')
#         time.sleep(1)
#         GPIO.output(ledPin_red, GPIO.HIGH) # led off
#         print ('led off red')
#         time.sleep(1)
#         GPIO.output(ledPin_green, GPIO.LOW) # led on
#         print ('led on green')
#         time.sleep(1)
#         GPIO.output(ledPin_green, GPIO.HIGH) # led off
#         print ('led off green')
#         time.sleep(1)
#         GPIO.output(ledPin_blue, GPIO.LOW) # led on
#         print ('led on blue')
#         time.sleep(1)
#         GPIO.output(ledPin_blue, GPIO.HIGH) # led off
#         print ('led off blue')
#         time.sleep(1)
#
#         GPIO.output(ledPin_red, GPIO.LOW) # led on
#         GPIO.output(ledPin_green, GPIO.LOW) # led on
#         GPIO.output(ledPin_blue, GPIO.LOW) # led on
#         print ('led on ALL')
#         time.sleep(1)
#
#         GPIO.output(ledPin_red, GPIO.HIGH) # led on
#         GPIO.output(ledPin_green, GPIO.HIGH) # led on
#         GPIO.output(ledPin_blue, GPIO.HIGH) # led on
#         print ('led off ALL')
#         time.sleep(1)
        
def destroy():
    GPIO.output(ledPin_red, GPIO.LOW) # led off 
    GPIO.output(ledPin_green, GPIO.LOW) # led off 
    GPIO.output(ledPin_blue, GPIO.LOW) # led off 
    GPIO.cleanup() # Release resource
        
if __name__ == '__main__': # Program start from here 
    setup()
    try: 
        loop()
    except KeyboardInterrupt: 
        # When 'Ctrl+C' is pressed, the child program destroy() will be executed.
        destroy()

while True:
    data, addr = sock.recvfrom(com.udpBuffer)
    print("received message: %s" % data)
    
    gotMessage(data)