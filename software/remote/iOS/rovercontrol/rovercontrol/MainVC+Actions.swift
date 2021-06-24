//
//  MainVC+Actions.swift
//  rovercontrol
//
//  Created by Jeanette Müller on 31.03.21.
//

import UIKit
import MJPEGStreamLib

extension MainVC {
    
    @IBAction func actionPause(_ sender: UIButton) {
        self.view.bringSubviewToFront(self.pauseOverlayView)
        self.pauseOverlayView.isHidden = false
        MovementManager.shared.pause = true
    }
    @IBAction func actionUnpause(_ sender: UIButton) {
        self.pauseOverlayView.isHidden = true
        MovementManager.shared.pause = false
    }
    @IBAction func actionDriveMode(_ sender: UIButton) {
        if let mySceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate{
            if let r = mySceneDelegate.rover {
                if r.driving == .Drive {
                    r.driving = .Rotate
                    
                }else{
                    r.driving = .Drive
                }
            }
        }
    }
    
    @IBAction func actionSpeed(_ sender: UIButton) {
        if let mySceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate{
            if let r = mySceneDelegate.rover {
                r.toggleSpeed()
                sender.isSelected = !sender.isSelected
            }
        }
    }
    func resetLightButtons() {
        for b in [self.buttonLightRed, self.buttonLightGreen] {
            if b?.backgroundColor != .white {
                b?.setTitleColor(b?.backgroundColor, for: .normal)
                b?.backgroundColor = .white
                
                b?.isSelected = false
            }
        }
    }
    @IBAction func actionLightRed(_ sender: UIButton) {
        if sender.isSelected {
            resetLightButtons()
            let d = Rover.HeadInformation(colorRed: 0, colorGreen: 0, colorBlue: 0)
            CommunicationManager.shared.sendHeadInformation(d)
        }else{
            resetLightButtons()
            sender.backgroundColor = .red
            sender.setTitleColor(.white, for: .normal)
            sender.isSelected = true
            
            let d = Rover.HeadInformation(colorRed: 1, colorGreen: 0, colorBlue: 0)
            CommunicationManager.shared.sendHeadInformation(d)
        }
    }
    @IBAction func actionLighGreen(_ sender: UIButton) {
        if sender.isSelected {
            resetLightButtons()
            let d = Rover.HeadInformation(colorRed: 0, colorGreen: 0, colorBlue: 0)
            CommunicationManager.shared.sendHeadInformation(d)
        }else{
            resetLightButtons()
            sender.backgroundColor = .green
            sender.setTitleColor(.white, for: .normal)
            sender.isSelected = true
            
            let d = Rover.HeadInformation(colorRed: 0, colorGreen: 1, colorBlue: 0)
            CommunicationManager.shared.sendHeadInformation(d)
        }
    }
    
    @IBAction func actionLaser(_ sender: UIButton) {
        
        if sender.isSelected {
            let d = Rover.HeadInformation(laser: 0)
            CommunicationManager.shared.sendHeadInformation(d)
            sender.setTitleColor(sender.backgroundColor, for: .normal)
            sender.backgroundColor = .white
            sender.isSelected = false
        }else{
            sender.backgroundColor = .red
            sender.setTitleColor(.white, for: .normal)
            sender.isSelected = true
            
            let d = Rover.HeadInformation(laser: 1)
            CommunicationManager.shared.sendHeadInformation(d)
        }
    }
    
    
}
