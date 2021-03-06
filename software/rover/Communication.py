import socket

class Communication:
    ip = ""
    
    udpBuffer = 2048
    
    def __init__(self, name):
        print("Init Communication %s" % name)

    def getPortForDrive(self):
        return 5001
        
    def getPortForSteer(self):
        return 5002
        
    def getPortForArm(self):
        return 5003
        
    def getPortForLight(self):
        return 5004
        
    def getPortForTower(self):
        return 5005
        
    def getPortForSound(self):
        return 5006
        
    def getPortForInfo(self):
        return 5007
    
    def getSocket(self): 
        s = socket.socket(socket.AF_INET, # Internet
                             socket.SOCK_DGRAM) # UDP
                             
        s.settimeout(5)
        return s
