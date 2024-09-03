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
    var udpClient_Tower: UDPClient?
    
    var delegate: CommunicationManagerDelegate?
    
    var gamePadIsConnected: Bool = false
    
    enum State {
        case Disconnected, Setup, Connecting, Connected, Cancelled, Failed
    }
    
    static let shared: CommunicationManager = {
        
        let instance = CommunicationManager()
        
        instance.udpRestart()
        
        return instance
    }()
    
    func startUdpClient(adress: String, port: Int32, asListener listen:Bool = false) -> UDPClient? {
        
        let client = UDPClient(address: adress, port: port, listener: listen)
        
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
    
    var mainIpAdress: String {
        get {
            switch GlobalSettings.getEnvironment() {
                case .Dev:
                    return "192.168.178.37"
                default:
                    return "192.168.50.10"
            }
        }
    }
    var towerIpAdress: String {
        get {
            switch GlobalSettings.getEnvironment() {
                case .Dev:
                    return "192.168.178.44"
                default:
                    return "192.168.50.185"
            }
        }
    }
    
    var frontCameraIpAdress: String {
        get {
            return "10.0.0.87"
        }
    }
    var towerCameraIpAdress: String {
        get {
            if let address = String.getIPAddress() {
                if address.count > 0 {
                    let parts = address.components(separatedBy: ".")
                    
                    if parts.count == 4 {
                        let first = parts[0]
                        let second = parts[1]
                        let third = parts[2]
                        if first == "192", second == "168", third == "178" {
                            return "192.168.178.38"
                        }
                    }
                }
            }
            return "192.168.50.10"
        }
    }
    
    func udpRestart() {
        
        if let drive = self.udpClient_Drive {
            drive.restart()
        }else {
            self.udpClient_Drive = self.startUdpClient(adress: mainIpAdress, port: 5001)
        }
        
        if let steer = self.udpClient_Steer {
            steer.restart()
        }else {
            self.udpClient_Steer = self.startUdpClient(adress: mainIpAdress, port: 5002)
        }
        
        if let tower = self.udpClient_Tower {
            tower.restart()
        }else {
            self.udpClient_Tower = self.startUdpClient(adress: mainIpAdress, port: 5005)
        }
    }
    func udpDisconnect() {
        self.udpClient_Drive?.disconnect()
        self.udpClient_Steer?.disconnect()
        self.udpClient_Tower?.disconnect()
        
        self.udpClient_Drive = nil
        self.udpClient_Steer = nil
        self.udpClient_Tower = nil
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
                "time": Int(Date().timeIntervalSince(Date(timeIntervalSince1970: 1636390000)) * 1000),
                "fl": Float(String(format:"%.4f", wr.fl))!,
                "fr": Float(String(format:"%.4f", wr.fr))!,
                "bl": Float(String(format:"%.4f", wr.bl))!,
                "br": Float(String(format:"%.4f", wr.br))!
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
                "time": Int(Date().timeIntervalSince(Date(timeIntervalSince1970: 1636390000)) * 1000),
                "ml":   Float(String(format:"%.4f", mi.left))!,
                "mlc":  Float(String(format:"%.4f", mi.leftCenter))!,
                "mr":   Float(String(format:"%.4f", mi.right))!,
                "mrc":  Float(String(format:"%.4f", mi.rightCenter))!
            ]
        ]
        
        self.sendData(sendData, to: self.udpClient_Steer)
        
        self.startMotorInformationRepeating(sendData)
    }
    var motorInformationRepeatTimer: Timer?
    var lastMotorInformation: [String: [String: Any]]?
    
    private func startMotorInformationRepeating(_ data: [String: [String: Any]]) {
        self.motorInformationRepeatTimer?.invalidate()
        self.motorInformationRepeatTimer = nil
        
        self.lastMotorInformation = data
        self.motorInformationRepeatTimer = Timer.scheduledTimer(timeInterval: 0.5,
                                                                target: self,
                                                                selector: #selector(repeatLastMotorInformation),
                                                                userInfo: nil,
                                                                repeats: true)
    }
    
    @objc func repeatLastMotorInformation() {
        if var data = self.lastMotorInformation {
            if self.gamePadIsConnected {
                
                data["drive"]?["time"] = Int(Date().timeIntervalSince(Date(timeIntervalSince1970: 1636390000)) * 1000)
                
                print("send again")
                self.sendData(data, to: self.udpClient_Steer)
            }
        }
    }
    
    func sendTowerInformation(_ tower:Rover.TowerInformation) {
        udpRestart()
        
        let sendData = [
            "tower": [
                "time": Int(Date().timeIntervalSince(Date(timeIntervalSince1970: 1636390000)) * 1000),
                //                "position": tower.position,
                "r": Float(String(format:"%.4f", tower.rotation))!,
                "t": Float(String(format:"%.4f", tower.tilt))!
            ]
        ]
        
        self.sendData(sendData, to: self.udpClient_Tower)
    }
    
    func sendData(_ data: [String: Any], to client:UDPClient?) {
        
        if client?.state == .ready {
            print("sendData \(data)")
            do {
                let d = try JSONSerialization.data(withJSONObject: data, options: [.withoutEscapingSlashes, .sortedKeys])
                
                client?.send(d)
            } catch let error as NSError {
                print("Failed to send: \(error.localizedDescription)")
            }
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
        
        var retry = false
        
        switch state {
            case let .waiting(error):
                print("State: waiting: \(error.localizedDescription)")
                self.state = .Setup
            case let .failed(error):
                print("State: failed: \(error.localizedDescription)")
                self.state = .Failed
                retry = true
            case .ready:
                print("State: Ready")
                self.state = .Connected
            case .setup:
                print("State: Setup")
                self.state = .Setup
            case .cancelled:
                print("State: Cancelled")
                self.state = .Cancelled
                
                retry = true
                
            case .preparing:
                print("State: Preparing")
                self.state = .Connecting
            default:
                print("CommunicationManager ERROR! State not defined!\n")
                self.state = .Disconnected
                
                retry = true
        }
        
        if retry {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.udpRestart();
            }
        }
        
    }
    
    func udpClient(_ client: UDPClient, didReceive data: Data) {
        
        self.delegate?.communicationManager(self, didReceive: data, fromClient: client)
    }
}
