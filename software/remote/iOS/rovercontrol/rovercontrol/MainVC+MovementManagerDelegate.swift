//
//  MainVC+MovementManagerDelegate.swift
//  rovercontrol
//
//  Created by Jeanette Müller on 30.03.21.
//

import UIKit
import GameController

extension MainVC: MovementManagerDelegate {
    
    var movementManagerDelegateIdentifier: String {
        get {
            return "MainVC"
        }
    }
    func inputManager(_ manager: MovementManager, didConnect controller: GCController) {
        
        DispatchQueue.main.async {
            self.gamePadConnectionState.backgroundColor = .green
            
            self.updateButtons()
        }
    }
    func inputManager(_ manager: MovementManager, didDisconnect controller: GCController) {
        
        self.gamePadConnectionState.backgroundColor = .red
        
    }
    func inputManager(_ manager: MovementManager, button: MovementManager.ButtonType, isPressed pressed: Bool, pressValue value: Float?) {
        
        switch button {
        case .ButtonX:
            if pressed {
                if self.optionsContainer.isHidden {
                    self.showOptionsOverlay()
                }else{
                    self.hideOptionsOverlay()
                }
            }
        default:
            return
        //nothing to do
        }
    }
    func inputManager(_ manager: MovementManager, thumbstick: MovementManager.ThumbstickType, x: Float, y: Float) {
        
    }
    func inputManagerDidChanged(_ manager: MovementManager, withUpdate update: MovementManager.MovementManagerUpdate) {
        
    }
}
