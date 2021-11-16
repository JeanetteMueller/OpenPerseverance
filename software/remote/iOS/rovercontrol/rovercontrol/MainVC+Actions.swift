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
            }
        }
    }
    func resetLightButtons() {
        for b in [self.buttonLightRed, self.buttonLightGreen, self.buttonLightBlue] {
            if b?.backgroundColor != buttonDefaultColor {
                b?.setTitleColor(b?.backgroundColor, for: .normal)
                b?.backgroundColor = buttonDefaultColor
            }
            b?.isSelected = false
        }
        
        self.lightsColorResult.backgroundColor = .black
        self.lightsColorResult.layer.cornerRadius = 8
    }
    
    @IBAction func openSettings(_ sender: UIButton) {
        self.performSegue(withIdentifier: "SettingsVC", sender: sender)
    }
    
    @IBAction func actionLightRed(_ sender: UIButton) {
        self.actionLight(sender, color: .red, on: !sender.isSelected)
    }
    @IBAction func actionLighGreen(_ sender: UIButton) {
        self.actionLight(sender, color: .green, on: !sender.isSelected)
        
    }
    @IBAction func actionLighBlue(_ sender: UIButton) {
        self.actionLight(sender, color: .blue, on: !sender.isSelected)
        
    }
    func actionLight(_ sender: UIButton, color: UIColor, on: Bool) {
        
        var d:Rover.HeadInformation
        
        let maxValue: Int = 1
        
        switch color {
            case .red:
                d = Rover.HeadInformation(colorRed: on ? maxValue : 0)
            case .green:
                d = Rover.HeadInformation(colorGreen: on ? maxValue : 0)
            case .blue:
                d = Rover.HeadInformation(colorBlue: on ? maxValue : 0)
            default:
                return
        }
        
        if on {
            sender.backgroundColor = color
            sender.setTitleColor(buttonDefaultColor, for: .normal)
            sender.isSelected = true
        }else {
            sender.setTitleColor(sender.backgroundColor, for: .normal)
            sender.backgroundColor = buttonDefaultColor
            sender.isSelected = false
        }
        
        CommunicationManager.shared.sendHeadInformation(d)
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        
        if self.buttonLightRed.isSelected {
            red = CGFloat(maxValue)
        }
        if self.buttonLightGreen.isSelected {
            green = CGFloat(maxValue)
        }
        if self.buttonLightBlue.isSelected {
            blue = CGFloat(maxValue)
        }
        self.lightsColorResult.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    @IBAction func actionLaser(_ sender: UIButton) {
        
        if sender.isSelected {
            let d = Rover.HeadInformation(laser: 0)
            CommunicationManager.shared.sendHeadInformation(d)
            sender.setTitleColor(sender.backgroundColor, for: .normal)
            sender.backgroundColor = buttonDefaultColor
            sender.isSelected = false
        }else{
            sender.backgroundColor = .red
            sender.setTitleColor(buttonDefaultColor, for: .normal)
            sender.isSelected = true
            
            let d = Rover.HeadInformation(laser: 1)
            CommunicationManager.shared.sendHeadInformation(d)
        }
    }
    
    
}
