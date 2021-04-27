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
            
            switch self.speed {
            case .Normal:
                return 80
            case .Fast:
                return 100
            default:
                return 40
            }
        }
    }
    

    var armJoint1max:Float { get { return 170 }}
    var armJoint1min:Float { get { return -20 }}
    
    var armJoint2max:Float { get { return 105 }}
    var armJoint2min:Float { get { return 6 }}
    
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
            case .R1:
                self.toggleSpeed()
            
            case .DpadLeft, .DpadRight, .DpadUp, .DpadDown:
                
                self.dpadPressedButton = button
                
                self.dpadRepearTimerAction(nil)
                
                self.dPadRepeatTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.dpadRepearTimerAction(_:)), userInfo: nil, repeats: true)
                
            default:
                //Nothing
                print("Nothing to do")
            }
        } else{
            switch button {
            
                case .DpadLeft, .DpadRight, .DpadUp, .DpadDown:
                    
                    if let t = self.dPadRepeatTimer {
                        t.invalidate()
                    }
                    self.dPadRepeatTimer = nil
                    self.dpadPressedButton = nil
                
            default:
                //Nothing
                print("Nothing to do")
            }
        }
        
        
    }
    @objc func dpadRepearTimerAction(_ sender: Any?) {
        
        print("dpadRepearTimerAction")
        
        if let button = self.dpadPressedButton {
            if button == .DpadLeft {
                self.armJoint1 += 1
            }else if button == .DpadRight {
                self.armJoint1 -= 1
            }
            if self.armJoint1 < self.armJoint1min {
                self.armJoint1 = self.armJoint1min
            }else if self.armJoint1 > self.armJoint1max {
                self.armJoint1 = self.armJoint1max
            }
            
            if button == .DpadUp {
                self.armJoint2 += 1
            }else if button == .DpadDown {
                self.armJoint2 -= 1
            }
            if self.armJoint2 < self.armJoint2min {
                self.armJoint2 = self.armJoint2min
            }else if self.armJoint2 > self.armJoint2max {
                self.armJoint2 = self.armJoint2max
            }
            
            //                let joint1_maxArmRotation:Float = 170
            //                let joint2_maxArmRotation:Float = 100
            //                let joint3_maxArmRotation:Float = 170
            //                let joint4_maxArmRotation:Float = 170
            //
            //                let joint1_halfArmRotation = joint1_maxArmRotation / 2
            //                let joint2_halfArmRotation = joint2_maxArmRotation / 2
            //                let joint3_halfArmRotation = joint3_maxArmRotation / 2
            //                let joint4_halfArmRotation = joint4_maxArmRotation / 2
            
            
            let arm = Rover.ArmInformation(joint1: self.armJoint1,
                                           joint2: self.armJoint2,
                                           joint3: self.armJoint3,
                                           joint4: self.armJoint4)
            
            self.topDownPositionView.updateArmInformation(arm)
            
            CommunicationManager.shared.sendArmInformation(arm)
        }
    }
    
    func inputManager(_ manager: MovementManager, thumbstick: MovementManager.ThumbstickType, x: Float, y: Float) {
        
    }
    func inputManagerDidChanged(_ manager: MovementManager, withUpdate update:MovementManager.MovementManagerUpdate){
        
        //print("updated position")
        
        statusReset()
        

        
        
        self.steeringCircleDistanceInner = nil
        self.steeringCircleDistanceOuter = nil
        
        
        
        //lenkung
        if self.driving == .Drive {
            
            if manager.current_rightThumbstick.x < 0 || manager.current_rightThumbstick.x > 0 {
                
                let winkelbereich: Float = 45
                
                let wunschwinkel = winkelbereich * Float(manager.current_rightThumbstick.x)
                
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
                
                self.steeringCircleDistanceInner = b
                
                let bAussen = b + self.width
                self.steeringCircleDistanceOuter = bAussen
                
                let aAussen = sqrt( pow(bAussen, 2) - 2*bAussen * a * cos(beta) + pow(a, 2) )
                
                var gammaAussen = ((0.5 * pow(aAussen, 2)) - (0.5 * pow(bAussen, 2)) + (0.5 * pow(a, 2)) ) / (aAussen * a)
                gammaAussen = acos(gammaAussen) * 180 / Float(Double.pi)
                
                let wunschwinkelAussen = 90 - gammaAussen
                
                append("wunschwinkel innen \(positivWunschWinkel)")
                append("wunschwinkel aussen \(wunschwinkelAussen)")
                
                if manager.current_rightThumbstick.x < 0 {
                    //nach links
                    let wheelRotation = Rover.WheelRotation(fl: self.maxSteerRadius - positivWunschWinkel,
                                                            fr: self.maxSteerRadius - wunschwinkelAussen,
                                                            bl: self.maxSteerRadius + positivWunschWinkel,
                                                            br: self.maxSteerRadius + wunschwinkelAussen)
                    
                    
                    self.topDownPositionView.updateWheelRotation(wheelRotation)
                    
                    CommunicationManager.shared.sendWheelRotation(wheelRotation)
                }else if manager.current_rightThumbstick.x > 0{
                    //nach rechts
                    
                    let wheelRotation = Rover.WheelRotation(fl: self.maxSteerRadius + wunschwinkelAussen,
                                                            fr: self.maxSteerRadius + positivWunschWinkel,
                                                            bl: self.maxSteerRadius - wunschwinkelAussen,
                                                            br: self.maxSteerRadius - positivWunschWinkel)
                    
                    self.topDownPositionView.updateWheelRotation(wheelRotation)
                    
                    CommunicationManager.shared.sendWheelRotation(wheelRotation)
                }
            }else{
                append("Geradeaus")
                
                let wheelRotation = Rover.WheelRotation(fl: self.maxSteerRadius,
                                                        fr: self.maxSteerRadius,
                                                        bl: self.maxSteerRadius,
                                                        br: self.maxSteerRadius)
                
                self.topDownPositionView.updateWheelRotation(wheelRotation)
                
                CommunicationManager.shared.sendWheelRotation(wheelRotation)
            }
            
            


            var mi = Rover.MotorInformation(left: 0,
                                            leftCenter:0,
                                            right: 0,
                                            rightCenter: 0)
            
            var motorMultiplierLeft: Float = 1
            var motorMultiplierLeftCenter: Float = 1
            var motorMultiplierRight: Float = 1
            var motorMultiplierRightCenter: Float = 1
            
            if let outer = steeringCircleDistanceOuter, let inner = steeringCircleDistanceInner {
                
                let a2 = pow(radStand / 2, 2)
                let b2_inner = pow(inner, 2)
                let b2_outer = pow(outer, 2)
                let innerFront = sqrt(a2 + b2_inner)
                let outerFront = sqrt(a2 + b2_outer)
                
                let motorPercentage = inner / outer
                
                print("motorPercentage \(motorPercentage)")
                
                if manager.current_rightThumbstick.x < 0 {
                    //nach links
                    motorMultiplierLeft = innerFront / outerFront
                    motorMultiplierLeftCenter = motorPercentage
                    motorMultiplierRightCenter = (outer + 2) / outerFront
                }else if manager.current_rightThumbstick.x > 0{
                    //nach rechts
                    motorMultiplierRight = innerFront / outerFront
                    motorMultiplierRightCenter = motorPercentage
                    motorMultiplierLeftCenter = (outer + 2) / outerFront
                }
                
                motorMultiplierLeft         = motorMultiplierLeft > 1.0 ? 1.0 : motorMultiplierLeft
                motorMultiplierLeftCenter   = motorMultiplierLeftCenter > 1.0 ? 1.0 : motorMultiplierLeftCenter
                motorMultiplierRight        = motorMultiplierRight > 1.0 ? 1.0 : motorMultiplierRight
                motorMultiplierRightCenter  = motorMultiplierRightCenter > 1.0 ? 1.0 : motorMultiplierRightCenter
            }
            
            
            if manager.current_TriggerR2 > 0 {
                append("Input: Trigger R2: \(manager.current_TriggerR2) ")
                mi.left         = manager.current_TriggerR2 * maxSpeed * motorMultiplierLeft
                mi.leftCenter   = manager.current_TriggerR2 * maxSpeed * motorMultiplierLeftCenter
                mi.right        = manager.current_TriggerR2 * maxSpeed * motorMultiplierRight
                mi.rightCenter  = manager.current_TriggerR2 * maxSpeed * motorMultiplierRightCenter
            }else if manager.current_TriggerL2 > 0 {
                append("Input: Trigger L2: \(manager.current_TriggerL2) ")
                mi.left         = -(manager.current_TriggerL2 * maxSpeed * motorMultiplierLeft)
                mi.leftCenter   = -(manager.current_TriggerL2 * maxSpeed * motorMultiplierLeftCenter)
                mi.right        = -(manager.current_TriggerL2 * maxSpeed * motorMultiplierRight)
                mi.rightCenter  = -(manager.current_TriggerL2 * maxSpeed * motorMultiplierRightCenter)
            }else{
                append("")
            }
            
            self.topDownPositionView.updateMotorInformation(mi)
            
            CommunicationManager.shared.sendMotorInformation(mi)
            
            
            
            
            
            
        }else if self.driving == .Rotate{
            //nur Motor
            
            let mi = Rover.MotorInformation(left: -(Float(manager.current_rightThumbstick.x) * maxSpeed),
                                            leftCenter: -(Float(manager.current_rightThumbstick.x) * maxSpeed * 0.9),
                                            right: Float(manager.current_rightThumbstick.x) * maxSpeed,
                                            rightCenter: Float(manager.current_rightThumbstick.x) * maxSpeed * 0.9)
            
            self.topDownPositionView.updateMotorInformation(mi)
            
            CommunicationManager.shared.sendMotorInformation(mi)
        }
        
        

        
    }
    func statusReset() {
        self.status = ""
    }
    func append(_ t:String) {
        self.status.append("\(t)\n")
        
        
        NotificationCenter.default.post(name: .RoverStateChanges, object: self)
    }
}
