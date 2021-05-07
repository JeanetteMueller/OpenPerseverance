
class Helper:
    
    def findI2C(self):
        i2cdetect -y
        #i2cdetect -y 1
        
    def getPulseFromAngle(self, angle, servo_min, servo_max):
        
        #print("Helper getPulseFromAngle angle: %f - %f - %f" % (angle, servo_min, servo_max))
    
        maxRange = servo_max - servo_min
        
        #print("Helper getPulseFromAngle maxRange: %f" % maxRange)
        
        partAngle = (angle * 1.0) / 180
        
        #print("Helper getPulseFromAngle partAngle: %f" % partAngle)
        
        angleMultiply = partAngle * maxRange
        
        #print("Helper getPulseFromAngle angleMultiply: %f" % angleMultiply)
        
        pulse = angleMultiply + servo_min
    
        #print("Helper getPulseFromAngle: %f" % pulse)
         
        return pulse