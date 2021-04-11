//
//  Rover+MovementManagerDelegate.swift
//  rovercontrol
//
//  Created by Jeanette Müller on 24.03.21.
//

import Foundation
import GameController

extension Notification.Name {
    static var RoverStateChanges = Notification.Name("RoverStateChanges")
}
extension Rover: MovementManagerDelegate {
    var movementManagerDelegateIdentifier: String {

        get {
            return "Rover01"
        }
    }
    
    func inputManager(_ manager: MovementManager, didConnect controller: GCController) {
        print("Und los gehts...")
    }
    
    func inputManager(_ manager: MovementManager, didDisconnect controller: GCController) {
        print("Controller verbindung verloren")
    }
    func closeRightOverlay() {
        //        self.overlayRightContainerRight.constant = -400
        //        UIView.animate(withDuration: 0.2) {
        //            self.view.layoutIfNeeded()
        //        }
    }
    
    var maxSpeed: Float {
        get {
            return self.speed == .Slow ? 25 : 100
        }
    }
    
    func inputManager(_ manager: MovementManager, button: MovementManager.ButtonType, isPressed pressed: Bool, pressValue value: Float?) {
        
        statusReset()
        
        if pressed {
            switch button {
            case .ButtonB:
                if self.driving == .Drive {
                    self.driving = .Rotate
                }else{
                    self.driving = .Drive
                }
            
            default:
                //Nothing
                print("Nothing to do")
            }
            
            
            
            if let v = value {
                let analogValue = String(format: "%.2f", v)
                
                print("input \(analogValue)")
                //            self.lastMovementLabel.text = button.rawValue + " " + analogValue
                
            }
            
            
        }else{
            if button == .R2 {
                let mi = Rover.MotorInformation(left: 0,
                                                leftCenter:0,
                                                right: 0,
                                                rightCenter: 0)
                CommunicationManager.shared.sendMotorInformation(mi)
            }
        }
        
        if self.driving == .Drive {
            if button == .R2 || button == .L2 {
                
                var mi = Rover.MotorInformation(left: 0,
                                                leftCenter:0,
                                                right: 0,
                                                rightCenter: 0)
                
                if manager.current_TriggerR2 > 0 {
                    append("Input: Trigger R2: \(manager.current_TriggerR2) ")
                    mi.left         = manager.current_TriggerR2 * maxSpeed
                    mi.leftCenter   = manager.current_TriggerR2 * maxSpeed
                    mi.right        = manager.current_TriggerR2 * maxSpeed
                    mi.rightCenter  = manager.current_TriggerR2 * maxSpeed
                }else if manager.current_TriggerL2 > 0 {
                    append("Input: Trigger L2: \(manager.current_TriggerL2) ")
                    mi.left         = -(manager.current_TriggerL2 * maxSpeed)
                    mi.leftCenter   = -(manager.current_TriggerL2 * maxSpeed)
                    mi.right        = -(manager.current_TriggerL2 * maxSpeed)
                    mi.rightCenter  = -(manager.current_TriggerL2 * maxSpeed)
                }else{
                    append("")
                }
                
                CommunicationManager.shared.sendMotorInformation(mi)
            }
        }
    }
    
    func inputManager(_ manager: MovementManager, thumbstick: MovementManager.ThumbstickType, x: Float, y: Float) {
        
        statusReset()
        
        append("Input: Thumbstick: \(thumbstick.rawValue) \(x) / \(y)")
        append("\n")
        //        self.lastMovementLabel.text = thumbstick.rawValue + " \(x) / \(y)"
        
        
        if thumbstick == .Right {
            
            //lenkung
            if self.driving == .Drive {
                
                if x < 0 || x > 0 {
                    
                    let winkelbereich: Float = 55 //45
                    
                    let wunschwinkel = winkelbereich * x
                    
                    var positivWunschWinkel = wunschwinkel
                    if positivWunschWinkel < 0 {
                        positivWunschWinkel = positivWunschWinkel * -1
                    }
                    
                    
                    let winkelAmRad:Float = 90 - positivWunschWinkel
                    let winkelImZentrum:Float = 90
                    let winkelAnKreisMittelpunkt:Float = 180 - winkelImZentrum - winkelAmRad
                    
                    let alpha = winkelAnKreisMittelpunkt * Float(Double.pi) / 180
                    let beta = winkelImZentrum * Float(Double.pi) / 180
                    let gamma = winkelAmRad * Float(Double.pi) / 180
                    
                    
                    let a = radStand / 2
                    let b = (a * sin(gamma)) / sin(alpha)
                    
                    let bAussen = b + self.width
                    let aAussen = sqrt( pow(bAussen, 2) - 2*bAussen * a * cos(beta) + pow(a, 2) )
                    
                    var gammaAussen = ((0.5 * pow(aAussen, 2)) - (0.5 * pow(bAussen, 2)) + (0.5 * pow(a, 2)) ) / (aAussen * a)
                    gammaAussen = acos(gammaAussen) * 180 / Float(Double.pi)
                    
                    let wunschwinkelAussen = 90 - gammaAussen
                    
                    append("wunschwinkel innen \(positivWunschWinkel)")
                    append("wunschwinkel aussen \(wunschwinkelAussen)")
                    
                    if x < 0 {
                        //nach links
                        let wheelRotation = Rover.WheelRotation(fl: self.maxSteerRadius - positivWunschWinkel,
                                                                fr: self.maxSteerRadius - wunschwinkelAussen,
                                                                bl: self.maxSteerRadius + positivWunschWinkel,
                                                                br: self.maxSteerRadius + wunschwinkelAussen)
                        
                        
                        CommunicationManager.shared.sendWheelRotation(wheelRotation)
                    }else if x > 0{
                        //nach rechts
                        
                        let wheelRotation = Rover.WheelRotation(fl: self.maxSteerRadius + wunschwinkelAussen,
                                                                fr: self.maxSteerRadius + positivWunschWinkel,
                                                                bl: self.maxSteerRadius - wunschwinkelAussen,
                                                                br: self.maxSteerRadius - positivWunschWinkel)
                        
                        CommunicationManager.shared.sendWheelRotation(wheelRotation)
                    }
                }else{
                    append("Geradeaus")
                    
                    let wheelRotation = Rover.WheelRotation(fl: self.maxSteerRadius,
                                                            fr: self.maxSteerRadius,
                                                            bl: self.maxSteerRadius,
                                                            br: self.maxSteerRadius)
                    
                    CommunicationManager.shared.sendWheelRotation(wheelRotation)
                }
                
                
                
//                let mi = Rover.MotorInformation(left: y * maxSpeed,
//                                                leftCenter: y * maxSpeed,
//                                                right: y * maxSpeed,
//                                                rightCenter: y * maxSpeed)
//
//                CommunicationManager.shared.sendMotorInformation(mi)
                
                
            }else if self.driving == .Rotate{
                //nur Motor
                
                let mi = Rover.MotorInformation(left: -(x * maxSpeed),
                                                leftCenter: -(x * maxSpeed * 0.9),
                                                right: x * maxSpeed,
                                                rightCenter: x * maxSpeed * 0.9)
                CommunicationManager.shared.sendMotorInformation(mi)
            }

        }
        
        if thumbstick == .Left {
            let maxArmRotation:Float = 170
            
            let halfArmRotation = maxArmRotation / 2
            
            let arm = Rover.ArmInformation(joint1: x * halfArmRotation + halfArmRotation,
                                           joint2: halfArmRotation,
                                           joint3: halfArmRotation,
                                           joint4: halfArmRotation)
            
            CommunicationManager.shared.sendArmInformation(arm)
        }
        
    
        
    }
    func inputManagerDidChanged(_ manager: MovementManager, withUpdate update:MovementManager.MovementManagerUpdate){
        
        print("updated position")
        
        //        self.tachikoma?.updatePositions(manager, withUpdate: update)
    }
    func statusReset() {
        self.status = ""
    }
    func append(_ t:String) {
        self.status.append("\(t)\n")
        
        
        NotificationCenter.default.post(name: .RoverStateChanges, object: self)
    }
}
