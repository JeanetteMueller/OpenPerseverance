//
//  ViewController.swift
//  rovercontrol
//
//  Created by Jeanette Müller on 19.03.21.
//

import UIKit
import GameController

class MainVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        MovementManager.shared.addDelegate(self)
        CommunicationManager.shared.delegate = self
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        //udpTestSend()
    }
    var testValue: Float = 0
    var moveUp = true
    var wait: Double = 0
    
    func udpTestSend() {
        print("udpTestSend")
        
        CommunicationManager.shared.sendWheelAngles(fl: testValue, fr: testValue, bl: testValue, br: testValue)
        
        if moveUp {
            self.testValue += 10
        }else{
            self.testValue -= 10
        }
        
        let maxValue: Float = 160
        
        if self.testValue > maxValue {
            moveUp = !moveUp
            self.testValue = maxValue
            
            wait = 1
        }
        if self.testValue < 0 {
            moveUp = !moveUp
            self.testValue = 0
            
            wait = 1
            
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.3 + wait, repeats: false) { (t) in
            self.udpTestSend()
            
            self.wait = 0
        }
        
    }

}

extension MainVC: MovementManagerDelegate {
    func inputManager(_ manager: MovementManager, didConnect controller: GCController) {
//        self.gamePadConnectionState.backgroundColor = .green
        
        print("Und los gehts...")
    }
    
    func inputManager(_ manager: MovementManager, didDisconnect controller: GCController) {
//        self.gamePadConnectionState.backgroundColor = .red
        
        print("Controller verbindung verloren")
    }
    func inputManager(_ manager: MovementManager, button: MovementManager.ButtonType, isPressed pressed: Bool) {
        
        /*
        if pressed {
            self.lastMovementLabel.text = button.rawValue + " down"
            
        } else {
            self.lastMovementLabel.text = button.rawValue + " up"
        }
        
        
        if pressed {
            if button == .Options {
                if self.overlayRightContainerRight.constant == -400 {
                    if let vc = self.storyboard?.instantiateViewController(withIdentifier: "OptionsListVC") as? OptionsListVC{
                        
                        self.overlayRightNav?.setViewControllers([vc], animated: false)
                        
                        self.overlayRightContainerRight.constant = 0
                        UIView.animate(withDuration: 0.2) {
                            self.view.layoutIfNeeded()
                        }
                    }
                }else{
                    self.closeRightOverlay()
                }
            }
        }
 */
    }
    func closeRightOverlay() {
//        self.overlayRightContainerRight.constant = -400
//        UIView.animate(withDuration: 0.2) {
//            self.view.layoutIfNeeded()
//        }
    }
    
    func inputManager(_ manager: MovementManager, button: MovementManager.ButtonType, isPressed pressed: Bool, pressValue value: Float?) {
        
        if pressed, let v = value {
            let analogValue = String(format: "%.2f", v)
            
            print("input \(analogValue)")
//            self.lastMovementLabel.text = button.rawValue + " " + analogValue
            
        }
    }
    
    func inputManager(_ manager: MovementManager, thumbstick: MovementManager.ThumbstickType, x: Float, y: Float) {
        
        print("thumbstick: \(thumbstick.rawValue) \(x) / \(y)")
//        self.lastMovementLabel.text = thumbstick.rawValue + " \(x) / \(y)"
        
        if thumbstick == .Right {
            
            //lenkung
            
            let radStand:Float = 48
            let roverBreite:Float = 50
            
            let target:Float = 80 //center grad wenn servos in der mitte
            
            let winkelbereich: Float = 45
            
//            if x < 0 {
//                target = target + winkelbereich * x
//            }else if x > 0 {
                
            let wunschwinkel = winkelbereich * x
            
            
            let kreisAbstandVonMitte = ((radStand/2) * sin(90 - wunschwinkel)) / sin(wunschwinkel)
            
            var grosserKreisVonMitte = kreisAbstandVonMitte + roverBreite
            
            if grosserKreisVonMitte < 0 {
                grosserKreisVonMitte = grosserKreisVonMitte * -1
            }
            
            let a = (radStand / 2)
            let b = grosserKreisVonMitte
            let c = sqrt(pow(a, 2) + pow(b, 2))
            
            var alpha = (-0.5 * pow(a, 2) + 0.5 * pow(b, 2) + 0.5 * pow(c, 2)) / ( b * c)
            alpha = acos(alpha) * 180.0 / Float(Double.pi)
            
            var beta = (0.5 * pow(a, 2) - 0.5 * pow(b, 2) + 0.5 * pow(c, 2)) / (a * c)
            beta = acos(beta) * 180.0 / Float(Double.pi)
            
            print("grosserKreisVonMitte \(grosserKreisVonMitte)")
            print("wunschwinkel innen \(wunschwinkel)  alpha \(alpha)  beta \(beta)")
            
            if x < 0 {
                CommunicationManager.shared.sendWheelAngles(fl: target + wunschwinkel,
                                                            fr: target + (90 - beta),
                                                            bl: 160 - target + wunschwinkel,
                                                            br: 160 - target + (90 - beta))
            }else if x > 0 {
                
                CommunicationManager.shared.sendWheelAngles(fl: target + (90 - beta),
                                                            fr: target + wunschwinkel,
                                                            bl: 160 - target + (90 - beta),
                                                            br: 160 - target + wunschwinkel)
            }
            
            //CommunicationManager.shared.sendWheelAngles(fl: target, fr: target, bl: 160 - target, br: 160 - target)
            
            //fahren
        }
        
        if thumbstick == .Left {
            //tower
        }
        
        
    }
    func inputManagerDidChanged(_ manager: MovementManager, withUpdate update:MovementManager.MovementManagerUpdate){
        
        print("updated position")
        
//        self.tachikoma?.updatePositions(manager, withUpdate: update)
    }
}


extension MainVC: CommunicationManagerDelegate {
    func communicationManager(_ m: CommunicationManager, didChange state: CommunicationManager.State) {
        switch state {
        case .Connected:
            print("State: Ready")
//            self.robotConnectionState.backgroundColor = .green
        case .Preparing:
            print("State: Setup")
//            self.robotConnectionState.backgroundColor = .red
        case .Cancelled:
            print("State: Cancelled")
//            self.robotConnectionState.backgroundColor = .darkGray
        case .Connecting:
            print("State: Preparing")
//            self.robotConnectionState.backgroundColor = .yellow
        default:
            print("ERROR! State not defined!\n")
//            self.robotConnectionState.backgroundColor = .red
        }
    }
    
    func communicationManager(_ m: CommunicationManager, didReceive data: Data) {
        
        
        
    }
}
