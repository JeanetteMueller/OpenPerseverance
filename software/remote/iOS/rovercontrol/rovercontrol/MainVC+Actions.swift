//
//  MainVC+Actions.swift
//  rovercontrol
//
//  Created by Jeanette Müller on 31.03.21.
//

import UIKit
import MJPEGStreamLib

extension MainVC {
    
    @IBAction func actionPause(_ sender: Any) {
        self.view.bringSubviewToFront(self.pauseOverlayView)
        self.pauseOverlayView.isHidden = false
        MovementManager.shared.pause = true
    }
    @IBAction func actionUnpause(_ sender: Any) {
        self.pauseOverlayView.isHidden = true
        MovementManager.shared.pause = false
    }
    @IBAction func actionDriveMode(_ sender: Any) {
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
    @IBAction func actionLights(_ sender: Any) {
        if let mySceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate{
            if let r = mySceneDelegate.rover {
                r.toggleAllLight()
            }
        }
    }
    @IBAction func actionSound(_ sender: Any) {
        
    }
    @IBAction func actionSpeed(_ sender: Any) {
        if let mySceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate{
            if let r = mySceneDelegate.rover {
                if r.speed == .Normal {
                    r.speed = .Slow
                }else{
                    r.speed = .Normal
                }
            }
        }
    }
    @IBAction func actionTower(_ sender: Any) {
        if let mySceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate{
            if let r = mySceneDelegate.rover {
                if r.tower.position > 17 {
                    r.tower = Rover.TowerInformation(position:17, rotation:0, tilt:0)
                }else{
                    r.tower = Rover.TowerInformation(position:110, rotation:0, tilt:0)
                }
            }
        }
    }
    @IBAction func actionPower(_ sender: Any) {
        CommunicationManager.shared.sendPowerInformation()
    }
    
    @IBAction func actionStartCamera1(_ sender: UIButton) {
        
        sender.isHidden = true
        
        // Set the ImageView to the stream object
        camera1Stream = MJPEGStreamLib(imageView: camera1ImageView)
        // Start Loading Indicator
        camera1Stream.didStartLoading = { [unowned self] in
            self.camera1LoadingIndicator.startAnimating()
            self.videoConnectionState.backgroundColor = .orange
        }
        // Stop Loading Indicator
        camera1Stream.didFinishLoading = { [unowned self] in
            self.camera1LoadingIndicator.stopAnimating()
            self.videoConnectionState.backgroundColor = .green
        }
        
        // Your stream url should be here !
        let url = URL(string: "http://192.168.178.44:81/stream")
        camera1Stream.contentURL = url
        camera1Stream.play() // Play the stream
    }
    @IBAction func actionStartCamera2(_ sender: UIButton) {
        
        //sender.isHidden = true
        
    }
}
