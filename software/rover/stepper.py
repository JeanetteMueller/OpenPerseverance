import RPi.GPIO as GPIO
import time
from DRV8825 import DRV8825



Motor1 = DRV8825(dir_pin=13, step_pin=19, enable_pin=12, mode_pins=(16 , 17, 20))
Motor2 = DRV8825(dir_pin=24, step_pin=18, enable_pin=4, mode_pins=(21, 22, 27))

"""
# 1.8 degree: nema23, nema14
# softward Control :
# 'fullstep': A cycle = 200 steps
# 'halfstep': A cycle = 200 * 2 steps
# '1/4step': A cycle = 200 * 4 steps
# '1/8step': A cycle = 200 * 8 steps
# '1/16step': A cycle = 200 * 16 steps
# '1/32step': A cycle = 200 * 32 steps
"""

#s = 200 * 32
#delay = 1.0 / s # 0.0005

#Motor1.TurnStep(Dir='forward', steps=s, stepdelay=delay)
#time.sleep(1.0)

#Motor1.TurnStep(Dir='backward', steps=s, stepdelay=delay)
#time.sleep(1.0)

#Motor2.TurnStep(Dir='forward', steps=s, stepdelay=delay)
#time.sleep(1.0)

#Motor2.TurnStep(Dir='backward', steps=s, stepdelay=delay)


#Motor1.Stop()
#Motor2.Stop()


def rotateBy(motor, deg, duration):

    dir = 'forward'
    if (deg < 0):
        dir = 'backward'
        deg = deg * -1
    s = 6406.0 / 16 / 360.0 * deg

    delay = 0
    if (duration > 0):
    	delay = duration / s

    #motor.SetMicroStep('software', 'halfstep')
    motor.TurnStep(Dir=dir, steps=int(s), stepdelay=delay)
    motor.Stop()

#rotateBy(Motor1, 90, 0.5)

rotateBy(Motor2, 90, 0.5)
