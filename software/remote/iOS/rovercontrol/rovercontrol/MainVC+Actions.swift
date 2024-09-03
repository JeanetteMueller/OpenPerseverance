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

}
