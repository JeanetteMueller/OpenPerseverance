//
//  MovementManager.swift
//  tachikomacontrol
//
//  Created by Jeanette Müller on 14.07.20.
//  Copyright © 2020 Jeanette Müller. All rights reserved.
//

import Foundation
import GameController

protocol MovementManagerDelegate {
    var movementManagerDelegateIdentifier: String { get }
    
    func inputManager(_ manager: MovementManager, didConnect controller: GCController)
    func inputManager(_ manager: MovementManager, didDisconnect controller: GCController)

    func inputManager(_ manager: MovementManager, button: MovementManager.ButtonType, isPressed pressed: Bool, pressValue value: Float?)

    func inputManager(_ manager: MovementManager, thumbstick: MovementManager.ThumbstickType, x: Float, y: Float)

    func inputManagerDidChanged(_ manager: MovementManager, withUpdate update:MovementManager.MovementManagerUpdate)
}



class MovementManager {
    
    struct MovementManagerUpdate {
        let eventType: EventType
        
        var buttonType: ButtonType? = nil
        var pressed: Bool? = nil
        var value: Float? = nil

        var thumbstickType: ThumbstickType? = nil
        var x: Float? = nil
        var y: Float? = nil
    }
    
    
    enum EventType: String {
        case None, Button, Trigger, Thumbstick
    }
    
    enum ButtonType: String {
        case DpadLeft,DpadRight, DpadUp, DpadDown
        case ButtonA, ButtonB, ButtonX, ButtonY
        case Share, Options
        case L1, L2, L3, R1, R2, R3
    }

    enum ThumbstickType: String{
        case Left, Right
    }
    
    var pause: Bool = false

    private let maximumControllerCount: Int = 1
    private(set) var controllers = Set<GCController>()

    // MARK: Current
    var current_ButtonDpadLeft = false
    var current_ButtonDpadRight = false
    var current_ButtonDpadUp = false
    var current_ButtonDpadDown = false
    var current_ButtonA = false
    var current_ButtonB = false
    var current_ButtonX = false
    var current_ButtonY = false
    var current_ButtonShare = false
    var current_ButtonOptions = false
    var current_ButtonL1 = false
    var current_ButtonL2 = false
    var current_ButtonL3 = false
    var current_ButtonR1 = false
    var current_ButtonR2 = false
    var current_ButtonR3 = false

    var current_TriggerL2: Float = 0
    var current_TriggerR2: Float = 0

    var current_leftThumbstick = CGPoint(x: 0, y: 0)
    var current_rightThumbstick = CGPoint(x: 0, y: 0)


    var delegates = [MovementManagerDelegate]()
    
    enum State {
        case Disconnected, Connected
    }
    
    var state = State.Disconnected {
        didSet {
            
        }
    }

    static let shared: MovementManager = {

        let instance = MovementManager()

        return instance
    }()
    func addDelegate(_ vc: MovementManagerDelegate){
        self.removeDelegate(vc)
        self.delegates.append(vc)
    }
    func removeDelegate(_ vc: MovementManagerDelegate){
        self.delegates = self.delegates.filter({ (v) -> Bool in
            if v.movementManagerDelegateIdentifier == vc.movementManagerDelegateIdentifier {
                return false
            }
            return true
        })
    }
    init() {

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didConnectController),
                                               name: NSNotification.Name.GCControllerDidConnect,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didDisconnectController),
                                               name: NSNotification.Name.GCControllerDidDisconnect,
                                               object: nil)

        GCController.startWirelessControllerDiscovery {}
    }
    @objc func didConnectController(_ notification: Notification) {
        print("didConnectController")

        guard controllers.count < maximumControllerCount else { return }
        let controller = notification.object as! GCController

        controllers.insert(controller)
        
        self.state = State.Connected

        for d in self.delegates {
            d.inputManager(self, didConnect: controller)
        }
        controller.extendedGamepad?.dpad.left.pressedChangedHandler =      { (button, value, pressed) in self.buttonChangedHandler(.DpadLeft, pressed) }
        controller.extendedGamepad?.dpad.right.pressedChangedHandler =     { (button, value, pressed) in self.buttonChangedHandler(.DpadRight, pressed) }
        controller.extendedGamepad?.dpad.up.pressedChangedHandler =        { (button, value, pressed) in self.buttonChangedHandler(.DpadUp, pressed) }
        controller.extendedGamepad?.dpad.down.pressedChangedHandler =      { (button, value, pressed) in self.buttonChangedHandler(.DpadDown, pressed) }

        // buttonA is labeled "X" (blue) on PS4 controller
        controller.extendedGamepad?.buttonA.pressedChangedHandler =        { (button, value, pressed) in self.buttonChangedHandler(.ButtonA, pressed) }
        // buttonB is labeled "circle" (red) on PS4 controller
        controller.extendedGamepad?.buttonB.pressedChangedHandler =        { (button, value, pressed) in self.buttonChangedHandler(.ButtonB, pressed) }
        // buttonX is labeled "square" (pink) on PS4 controller
        controller.extendedGamepad?.buttonX.pressedChangedHandler =        { (button, value, pressed) in self.buttonChangedHandler(.ButtonX, pressed) }
        // buttonY is labeled "triangle" (green) on PS4 controller
        controller.extendedGamepad?.buttonY.pressedChangedHandler =        { (button, value, pressed) in self.buttonChangedHandler(.ButtonY, pressed) }

        // buttonOptions is labeled "SHARE" on PS4 controller
        controller.extendedGamepad?.buttonOptions?.pressedChangedHandler = { (button, value, pressed) in self.buttonChangedHandler(.Share, pressed) }
        // buttonMenu is labeled "OPTIONS" on PS4 controller
        controller.extendedGamepad?.buttonMenu.pressedChangedHandler =     { (button, value, pressed) in self.buttonChangedHandler(.Options, pressed) }

        controller.extendedGamepad?.leftShoulder.pressedChangedHandler =   { (button, value, pressed) in self.buttonChangedHandler(.L1, pressed) }
        controller.extendedGamepad?.rightShoulder.pressedChangedHandler =  { (button, value, pressed) in self.buttonChangedHandler(.R1, pressed) }

        controller.extendedGamepad?.leftTrigger.pressedChangedHandler =    { (button, value, pressed) in self.buttonChangedHandler(.L2, pressed) }
        controller.extendedGamepad?.leftTrigger.valueChangedHandler =      { (button, value, pressed) in self.triggerChangedHandler(.L2, pressed, value) }
        controller.extendedGamepad?.rightTrigger.pressedChangedHandler =   { (button, value, pressed) in self.buttonChangedHandler(.R2, pressed) }
        controller.extendedGamepad?.rightTrigger.valueChangedHandler =     { (button, value, pressed) in self.triggerChangedHandler(.R2, pressed, value) }

        controller.extendedGamepad?.leftThumbstick.valueChangedHandler =   { (button, xvalue, yvalue) in self.thumbstickChangedHandler(.Left, xvalue, yvalue) }
        controller.extendedGamepad?.rightThumbstick.valueChangedHandler =  { (button, xvalue, yvalue) in self.thumbstickChangedHandler(.Right, xvalue, yvalue) }

        controller.extendedGamepad?.leftThumbstickButton?.pressedChangedHandler =  { (button, value, pressed) in self.buttonChangedHandler(.L3, pressed) }
        controller.extendedGamepad?.rightThumbstickButton?.pressedChangedHandler = { (button, value, pressed) in self.buttonChangedHandler(.R3, pressed) }
    }

    @objc func didDisconnectController(_ notification: Notification) {
        print("didDisconnectController")

        let controller = notification.object as! GCController
        controllers.remove(controller)
        
        self.state = State.Disconnected

        if !self.pause {
            for d in self.delegates {
                d.inputManager(self, didDisconnect: controller)
            }
        }
    }

    func buttonChangedHandler(_ button: ButtonType, _ pressed: Bool) {
        if pressed {
            //print("buttonChangedHandler " + button.rawValue + " " + "down")
        } else {
            //print("buttonChangedHandler " + button.rawValue + " " + "up")
        }

        switch button {
            case .DpadLeft:
                current_ButtonDpadLeft = pressed
            case .DpadRight:
                current_ButtonDpadRight = pressed
            case .DpadUp:
                current_ButtonDpadUp = pressed
            case .DpadDown:
                current_ButtonDpadDown = pressed
            case .ButtonA:
                current_ButtonA = pressed
            case .ButtonB:
                current_ButtonB = pressed
            case .ButtonX:
                current_ButtonX = pressed
            case .ButtonY:
                current_ButtonY = pressed
            case .Share:
                current_ButtonShare = pressed
            case .Options:
                current_ButtonOptions = pressed
            case .L1:
                current_ButtonL1 = pressed
            case .L2:
                current_ButtonL2 = pressed
            case .L3:
                current_ButtonL3 = pressed
            case .R1:
                current_ButtonR1 = pressed
            case .R2:
                current_ButtonR2 = pressed
            case .R3:
                current_ButtonR3 = pressed
        }
        
        if !self.pause {
            for d in self.delegates {
                d.inputManager(self, button: button, isPressed: pressed, pressValue: nil)
                d.inputManagerDidChanged(self, withUpdate: MovementManagerUpdate(eventType: .Button, buttonType: button, pressed: pressed))
            }
        }
    }
    func triggerChangedHandler(_ button: ButtonType, _ pressed: Bool, _ value: Float) {
        if pressed {
//            let analogValue = String(format: "%.2f", value)
//            print("triggerChangedHandler " + button.rawValue + " " + analogValue)
        }

        if button == .L2 {
            self.current_ButtonL2 = pressed
            self.current_TriggerL2 = value
        }
        if button == .R2 {
            self.current_ButtonR2 = pressed
            self.current_TriggerR2 = value
        }

        if !self.pause {
            for d in self.delegates {
                d.inputManager(self, button: button, isPressed: pressed, pressValue: value)
                d.inputManagerDidChanged(self, withUpdate: MovementManagerUpdate(eventType: .Trigger, buttonType: button, pressed: pressed, value: value))
            }
        }
    }

    func thumbstickChangedHandler(_ button: ThumbstickType, _ xvalue: Float, _ yvalue: Float) {
       let analogValueX = String(format: "%.2f", xvalue)
        let analogValueY = String(format: "%.2f", yvalue)
        print("thumbstickChangedHandler " + button.rawValue + " " + analogValueX + " / " + analogValueY)

        switch button {
            case .Left:
                self.current_leftThumbstick = CGPoint(x: CGFloat(xvalue), y: CGFloat(yvalue))
            case .Right:
                self.current_rightThumbstick = CGPoint(x: CGFloat(xvalue), y: CGFloat(yvalue))
        }

        if !self.pause {
            for d in self.delegates {

                d.inputManager(self, thumbstick: button, x: xvalue, y: yvalue)
                d.inputManagerDidChanged(self, withUpdate: MovementManagerUpdate(eventType: .Thumbstick, thumbstickType: button, x: xvalue, y: yvalue))
            }
        }
    }
}
