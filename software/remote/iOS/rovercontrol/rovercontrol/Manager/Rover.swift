//
//  Rover.swift
//  rovercontrol
//
//  Created by Jeanette Müller on 19.03.21.
//

import UIKit

extension Notification.Name {
    static var RoverDriveModeChanges = Notification.Name("RoverDriveModeChanges")
    static var RoverSpeedModeChanges = Notification.Name("RoverSpeedModeChanges")
}



class Rover {
    typealias WheelRotation = (fl:Float, fr:Float, bl:Float, br:Float)
    typealias MotorInformation = (left:Float, leftCenter:Float, right:Float, rightCenter:Float)
    typealias ArmInformation = (joint1:Float, joint2:Float, joint3:Float, joint4:Float)
    typealias LightInformation = (light1:Int, light2:Int, light3:Int, light4:Int)
    typealias TowerInformation = (rotation:Float, tilt:Float)
    typealias SoundInformation = (file:String, action:Int)
    
    struct HeadInformation {
        var colorRed: Int?
        var colorGreen: Int?
        var colorBlue: Int?
        var laser: Int?
    }
    
    var pause: Bool = false
//    {
//        didSet {
//            if self.pause {
//                MovementManager.shared.removeDelegate(self)
//            }else{
//                MovementManager.shared.addDelegate(self)
//            }
//        }
//    }
    
    enum Wheels {
        case FrontRight, FrontLeft, BackRight, BackLeft
    }
    
    enum Drive {
        case Drive, Rotate
    }
    
    enum Speed {
        case Slow, Normal, Fast
    }
    
//    enum Tower {
//        case Up, Down
//    }
    
    var driving = Drive.Drive {
        didSet {
            if self.driving == .Rotate {
                append("Set drive: Rotate")
                
                let wr = Rover.WheelRotation(fl: self.maxSteerRadius + 43.45, fr: self.maxSteerRadius - 43.45,
                                             bl: self.maxSteerRadius - 43.45, br: self.maxSteerRadius + 43.45)
                
                self.topDownPositionView.updateWheelRotation(wr)
                
                CommunicationManager.shared.sendWheelRotation(wr)
                
            }else{
                append("Set drive: Drive")
                
                let wr = Rover.WheelRotation(fl: self.maxSteerRadius, fr: self.maxSteerRadius,
                                             bl: self.maxSteerRadius, br: self.maxSteerRadius)
                
                self.topDownPositionView.updateWheelRotation(wr)
                
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
    func toggleSpeed() {
        if self.speed == .Slow {
            self.speed = .Normal
        }else if self.speed == .Normal {
            self.speed = .Fast
        }else{
            self.speed = .Slow
        }
    }
    
    var armJoint1:Float = 170 / 2
    var armJoint2:Float = 170 / 2
    var armJoint3:Float = 170 / 2
    var armJoint4:Float = 170 / 2
    
    var dpadPressedButton: MovementManager.ButtonType?
    var dPadRepeatTimer:Timer?
    
    
    var lights = LightInformation(light1: 0, light2: 0, light3: 0, light4: 0) {
        didSet {
            self.topDownPositionView.updateLightInformation(self.lights)
            
            CommunicationManager.shared.sendLightInformation(self.lights)
        }
    }
    
    
    let maxTowerRotate:Float = 170
    let rangeTowerRotate:Float = 4
    
    let maxTowerTilt:Float = 170
    let rangeTowerTilt:Float = 85
    var currentTowerTilt:Float = 85
    var towerIsTilting:Bool = false
    
    var tower = TowerInformation(rotation: 170 / 2, tilt: 170 / 2) {
        didSet {
            self.topDownPositionView.updateTowerInformation(self.tower)
            
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
    var width: Float = 30 + (2 * 9) + 8.8
    
    let maxSteerRadius:Float = 80
    
    init() {
        
    }
    
    private var roverTopDownPositionView:RoverTopDownPositionView?
    var topDownPositionView: RoverTopDownPositionView {
        get {
            if self.roverTopDownPositionView == nil {
                self.roverTopDownPositionView = RoverTopDownPositionView(withRover: self)
            }
            return self.roverTopDownPositionView!
        }
    }
    
    private var roverSpeedView: RoverSpeedView?
    var speedView: RoverSpeedView {
        get {
            if self.roverSpeedView == nil {
                self.roverSpeedView = RoverSpeedView(withRover: self)
            }
            return self.roverSpeedView!
        }
    }
    
    func getStatus() -> String {
        var s = ""
        
        s.append(self.status)
        
        return s
    }
    
    
    var steeringCircleDistanceInner: Float?
    var steeringCircleDistanceOuter: Float?
}
