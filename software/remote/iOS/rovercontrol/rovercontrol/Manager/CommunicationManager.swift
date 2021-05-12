//
//  CommunicationManager.swift
//  rovercontrol
//
//  Created by Jeanette Müller on 19.03.21.
//

import Foundation
import Network

protocol CommunicationManagerDelegate {
    func communicationManager(_ m: CommunicationManager, didReceive data: Data, fromClient client: UDPClient)
    func communicationManager(_ m: CommunicationManager, didChange state: CommunicationManager.State)
}
class CommunicationManager {
    var state: CommunicationManager.State = .Disconnected {
        didSet {
            self.delegate?.communicationManager(self, didChange: self.state)
        }
    }
    var udpClient_Drive: UDPClient?
    var udpClient_Steer: UDPClient?
    var udpClient_Arm: UDPClient?
    var udpClient_Light: UDPClient?
    var udpClient_Tower: UDPClient?
    var udpClient_Sound: UDPClient?
    var udpClient_Info: UDPClient?
    
    var udpClient_Head: UDPClient?
    
    var delegate: CommunicationManagerDelegate?
    
    enum State {
        case Disconnected, Preparing, Connecting, Connected, Cancelled, Failed
    }
    
    static let shared: CommunicationManager = {
        
        let instance = CommunicationManager()
        
        instance.udpRestart()
        
        
        
        return instance
    }()
    
    func startUdpClient(adress: String, port: Int32, asListener listen:Bool = false) -> UDPClient? {
        
        var client:UDPClient?
        if let ip = String.getIPAddress(), ip.hasPrefix("10.0"){
            client = UDPClient(address: adress, port: port, listener: listen)
        }else{
            //client = UDPClient(address: "192.168.178.55", port: port, listener: listen) // pi zero
            client = UDPClient(address: adress, port: port, listener: listen) // pi 3
        }
        client?.delegate = self
        
        client?.connect()
        
        return client
    }
    var lastMovementWheelRotation: Date = Date()
    var timerWheelRotation: Timer?
    var lastSendWheelRotation: Rover.WheelRotation?
    
    var lastMovementMotorInformation: Date = Date()
    var timerMotorInformation: Timer?
    var lastSendMotorInformation: Rover.MotorInformation?
    
    var lastArmInformation: Date = Date()
    var timerArmInformation: Timer?
    var lastSendArmInformation: Rover.ArmInformation?
    
    var calibrate = 0
    
    func udpRestart() {
        
        calibrate = 0
        
        if self.udpClient_Drive == nil {
            self.udpClient_Drive = self.startUdpClient(adress: "10.0.0.5", port: 5001)
        }else if udpClient_Drive!.state != .ready{
            self.udpClient_Drive!.connect()
        }
        
        if self.udpClient_Steer == nil {
            self.udpClient_Steer = self.startUdpClient(adress: "10.0.0.5", port: 5002)
        }else if udpClient_Steer!.state != .ready{
            self.udpClient_Steer!.connect()
        }

        if self.udpClient_Arm == nil {
            self.udpClient_Arm = self.startUdpClient(adress: "10.0.0.5", port: 5003)
        }else if udpClient_Arm!.state != .ready{
            self.udpClient_Arm!.connect()
        }
        
        if self.udpClient_Light == nil {
            self.udpClient_Light = self.startUdpClient(adress: "10.0.0.5", port: 5004)
        }else if udpClient_Light!.state != .ready{
            self.udpClient_Light!.connect()
        }
        
        if self.udpClient_Tower == nil {
            self.udpClient_Tower = self.startUdpClient(adress: "10.0.0.5", port: 5005)
        }else if udpClient_Tower!.state != .ready{
            self.udpClient_Tower!.connect()
        }
        
        if self.udpClient_Sound == nil {
            self.udpClient_Sound = self.startUdpClient(adress: "10.0.0.5", port: 5006)
        }else if udpClient_Sound!.state != .ready{
            self.udpClient_Sound!.connect()
        }
        
        
        if self.udpClient_Head == nil {
            self.udpClient_Head = self.startUdpClient(adress: "10.0.0.85", port: 5004)
        }else if udpClient_Head!.state != .ready{
            self.udpClient_Head!.connect()
        }
    }
    
    func udpRestart_Info() {
        if self.udpClient_Info == nil {
            self.udpClient_Info = self.startUdpClient(adress: "10.0.0.5", port: 5007, asListener: true)
        }else if udpClient_Info!.state != .ready{
            self.udpClient_Info!.connect()
        }
    }
    
    func sendWheelRotation(_ wr: Rover.WheelRotation) {
        udpRestart()
        
        if Date().millisecondsSince1970 < lastMovementWheelRotation.millisecondsSince1970 + 50 {
            //print("not send")

            self.lastSendWheelRotation = wr

            if self.timerWheelRotation != nil {
                self.timerWheelRotation?.invalidate()
            }
            self.timerWheelRotation = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (t) in

                if let wr = self.lastSendWheelRotation{

                    //print("send again")
                    self.sendWheelRotation(wr)
                }
            }
            return
        }
        lastMovementWheelRotation = Date()
        
        let sendData = [
            "steer":[
                "fl": wr.fl,
                "fr": wr.fr,
                "bl": wr.bl,
                "br": wr.br
            ]
        ]
        
        self.sendData(sendData, to: self.udpClient_Steer)
    }
    func sendMotorInformation(_ mi: Rover.MotorInformation) {
        udpRestart()
        
        if Date().millisecondsSince1970 < lastMovementMotorInformation.millisecondsSince1970 + 50 {
            //print("not send")
            
            self.lastSendMotorInformation = mi
            
            if self.timerMotorInformation != nil {
                self.timerMotorInformation?.invalidate()
            }
            self.timerMotorInformation = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (t) in
                
                if let mi = self.lastSendMotorInformation{
                    
                    //print("send again")
                    self.sendMotorInformation(mi)
                }
            }
            return
        }
        lastMovementMotorInformation = Date()
        
        let sendData = [
            "drive":[
                "ml":   mi.left,
                "mlc":  mi.leftCenter,
                "mr":   mi.right,
                "mrc":  mi.rightCenter
            ]
        ]
        
        self.sendData(sendData, to: self.udpClient_Drive)
    }
    func sendArmInformation(_ arm: Rover.ArmInformation) {
        udpRestart()
        
        if Date().millisecondsSince1970 < lastArmInformation.millisecondsSince1970 + 5 {
            //print("not send")

            self.lastSendArmInformation = arm

            if self.timerArmInformation != nil {
                self.timerArmInformation?.invalidate()
            }
            self.timerArmInformation = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (t) in

                if let mi = self.lastSendArmInformation{

                    //print("send again")
                    self.sendArmInformation(mi)
                }
            }
            return
        }
        lastArmInformation = Date()
        
        let sendData = [
            "arm":[
                "1": arm.joint1,
                "2": arm.joint2,
                "3": arm.joint3,
                "4": arm.joint4
            ]
        ]
        
        self.sendData(sendData, to: self.udpClient_Arm)
    }
    func sendLightInformation(_ li:Rover.LightInformation) {
        udpRestart()
        
        let sendData = [
            "light":[
                "1": li.light1,
                "2": li.light2,
                "3": li.light3,
                "4": li.light4
            ]
        ]
        
        self.sendData(sendData, to: self.udpClient_Light)
    }
    func sendTowerInformation(_ tower:Rover.TowerInformation) {
        udpRestart()
        
        let sendData = [
            "tower": [
//                "position": tower.position,
                "rotation": tower.rotation,
                "tilt": tower.tilt
            ]
        ]
        
        self.sendData(sendData, to: self.udpClient_Tower)
    }
    func sendSoundInformation(_ sound:Rover.SoundInformation) {
        udpRestart()
        
        let sendData = [
            "sound": [
                "file": sound.file,
                "action": sound.action
            ]
        ]
        
        self.sendData(sendData, to: self.udpClient_Sound)
    }
    func sendInfoInformation() {
        udpRestart_Info()
        
        let sendData = [
            "info": [
                "get": "accu"
                
            ]
        ]
        
        self.sendData(sendData, to: self.udpClient_Info)
    }
    func sendHeadInformation(_ d:Rover.HeadInformation) {
        udpRestart()
        
        let sendData = [
            "head":[
                "r": d.colorRed,
                "g": d.colorGreen,
                "b": d.colorBlue
            ]
        ]
        
        self.sendData(sendData, to: self.udpClient_Head)
    }
    
    
    func sendData(_ data: Any, to client:UDPClient?) {
        print("sendData \(data)")
        
        do {
            let d = try JSONSerialization.data(withJSONObject: data, options: [.withoutEscapingSlashes, .sortedKeys])
            
            client?.send(d)
        } catch let error as NSError {
            print("Failed to send: \(error.localizedDescription)")
        }
    }
}
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
extension CommunicationManager: UDPClientDelegate {
    func udpClient(_ client: UDPClient, didChange state: NWConnection.State) {
        switch state {
        case .ready:
            print("State: Ready")
            self.state = .Connected
        case .setup:
            print("State: Setup")
            self.state = .Preparing
        case .cancelled:
            print("State: Cancelled")
            self.state = .Cancelled
        case .preparing:
            print("State: Preparing")
            self.state = .Connecting
        default:
            print("ERROR! State not defined!\n")
            self.state = .Disconnected
        }
        
    }
    
    func udpClient(_ client: UDPClient, didReceive data: Data) {
        
        self.delegate?.communicationManager(self, didReceive: data, fromClient: client)
        
        if client.isListening {
            
            if client.port == self.udpClient_Info?.port {
                
                client.disconnect()
                
                client.delegate = nil
                self.udpClient_Info?.delegate = nil
                self.udpClient_Info = nil
                
            }
            
        }
    }
}
