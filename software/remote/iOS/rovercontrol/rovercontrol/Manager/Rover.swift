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
    
    
    struct WheelRotation {
        let fl: Float
        let fr: Float
        let bl: Float
        let br: Float
        
        init(fl: Float, fr: Float, bl: Float, br: Float) {
            self.fl = fl + GlobalSettings.getCalibrationFrontLeft()
            self.fr = fr + GlobalSettings.getCalibrationFrontRight()
            self.bl = bl + GlobalSettings.getCalibrationBackLeft()
            self.br = br + GlobalSettings.getCalibrationBackRight()
        }
    }
    
    //typealias WheelRotation = (fl:Float, fr:Float, bl:Float, br:Float)
    typealias MotorInformation = (left:Float, leftCenter:Float, right:Float, rightCenter:Float)
    typealias TowerInformation = (rotation:Float, tilt:Float)
    
    var pause: Bool = false
    
    enum Wheels {
        case FrontRight, FrontLeft, BackRight, BackLeft
    }
    
    enum Drive {
        case Drive, Rotate
    }
    
    enum Speed: Float {
        case Slow = 0.40
        case Normal = 0.70
        case Fast = 1.0
    }
    
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
    
    let maxTowerRotate:CGFloat = 170
    let rangeTowerRotate:Float = 3
    
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
