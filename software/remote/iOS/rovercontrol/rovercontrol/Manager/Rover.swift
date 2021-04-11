//
//  Rover.swift
//  rovercontrol
//
//  Created by Jeanette Müller on 19.03.21.
//

import Foundation

extension Notification.Name {
    static var RoverDriveModeChanges = Notification.Name("RoverDriveModeChanges")
    static var RoverSpeedModeChanges = Notification.Name("RoverSpeedModeChanges")
}


class Rover {
    typealias WheelRotation = (fl:Float, fr:Float, bl:Float, br:Float)
    typealias MotorInformation = (left:Float, leftCenter:Float, right:Float, rightCenter:Float)
    typealias ArmInformation = (joint1:Float, joint2:Float, joint3:Float, joint4:Float)
    typealias LightInformation = (light1:Int, light2:Int, light3:Int, light4:Int)
    
    var pause: Bool = false {
        didSet {
            if self.pause {
                MovementManager.shared.removeDelegate(self)
            }else{
                MovementManager.shared.addDelegate(self)
            }
        }
    }
    
    enum Wheels {
        case FrontRight, FrontLeft, BackRight, BackLeft
    }
    
    enum Drive {
        case Drive, Rotate
    }
    
    enum Speed {
        case Normal, Slow
    }
    
    enum Tower {
        case Up, Down
    }
    
    var driving = Drive.Drive {
        didSet {
            if self.driving == .Rotate {
                append("Set drive: Rotate")
                
                let wr = Rover.WheelRotation(fl: self.maxSteerRadius + 43.45, fr: self.maxSteerRadius - 43.45,
                                             bl: self.maxSteerRadius - 43.45, br: self.maxSteerRadius + 43.45)
                
                CommunicationManager.shared.sendWheelRotation(wr)
                
                
            }else{
                append("Set drive: Drive")
                let wr = Rover.WheelRotation(fl: self.maxSteerRadius, fr: self.maxSteerRadius,
                                             bl: self.maxSteerRadius, br: self.maxSteerRadius)
                
                CommunicationManager.shared.sendWheelRotation(wr)
            }
            
            NotificationCenter.default.post(name: .RoverDriveModeChanges, object: self)
        }
    }
    var speed = Speed.Slow {
        didSet {
            switch self.speed {
            case .Slow:
                append("Set Speed: Slow")
            default:
                append("Set Speed: Normal")
            }
            
            NotificationCenter.default.post(name: .RoverSpeedModeChanges, object: self)
        }
    }
    
    var lights = LightInformation(light1: 0, light2: 0, light3: 0, light4: 0) {
        didSet {
            CommunicationManager.shared.sendLightInformation(self.lights)
        }
    }
    
    var tower = Tower.Down {
        didSet {
            CommunicationManager.shared.sendTowerInformation(self.tower)
        }
    }
    
    func toggleAllLight() {
        
        let multi = 12 // 16
        
        if self.lights.light1 > 0 {
            self.lights = LightInformation(light1: 0, light2: 0, light3: 0, light4: 0)
        }else{
            self.lights = LightInformation(light1: 255 * multi, light2: 255 * multi, light3: 255 * multi, light4: 255 * multi)
        }
        
//        var multi = self.lights.light1 + 1
//
//        if multi > 16 {
//            multi = 0
//        }
//
//        self.lights = LightInformation(light1: multi, light2: 255, light3: 255, light4: 255 * multi)
        
    }
    
    
    var status = ""
    
    var radStand: Float = 54
    var width: Float = 57
    
    let maxSteerRadius:Float = 80
    
    init() {
        
        
        
    }
    
    func getStatus() -> String {
        var s = ""
        
        s.append(self.status)
        
        return s
    }
}