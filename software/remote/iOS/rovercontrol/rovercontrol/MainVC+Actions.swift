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
    @IBAction func actionSpeed(_ sender: Any) {
        if let mySceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate{
            if let r = mySceneDelegate.rover {
                r.toggleSpeed()
            }
        }
    }
    
    @IBAction func actionStartCamera1(_ sender: UIButton) {
        print("actionStartCamera1")
        
        if sender.title(for: .normal) == "Start" {
        
            sender.setTitle("", for: .normal)
            
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
            //let url = URL(string: "http://192.168.178.44:81/stream")
            let url = URL(string: "http://10.0.0.87:81/stream")
            camera1Stream.contentURL = url
            camera1Stream.play() // Play the stream
            
        }else{
            camera1Stream.stop()
            camera1ImageView.image = nil
            self.camera1LoadingIndicator.stopAnimating()
            sender.setTitle("Start", for: .normal)
        }
    }
    @IBAction func actionZoomCamera1(_ sender: UIButton) {
        
        if camera1height.constant == self.view.bounds.height {
            camera1height.constant = camera1BasicHeight
            
        }else{
            camera1height.constant = self.view.bounds.height
            camera2Height.constant = camera2BasicHeight
            camera3Height.constant = camera3BasicHeight
            self.view.bringSubviewToFront(camera1ImageView)
            self.view.bringSubviewToFront(camera1StartButton)
            self.view.bringSubviewToFront(camera1Label)
            self.view.bringSubviewToFront(camera1LoadingIndicator)
            self.view.bringSubviewToFront(sender)
        }
        
        animateCameraScreen()
    }
    
    @IBAction func actionStartCamera2(_ sender: UIButton) {
        
        if sender.title(for: .normal) == "Start" {
            
            sender.setTitle("", for: .normal)
            
            // Set the ImageView to the stream object
            camera2Stream = MJPEGStreamLib(imageView: camera2ImageView)
            // Start Loading Indicator
            camera2Stream.didStartLoading = { [unowned self] in
                self.camera2LoadingIndicator.startAnimating()
                self.videoConnectionState.backgroundColor = .orange
            }
            // Stop Loading Indicator
            camera2Stream.didFinishLoading = { [unowned self] in
                self.camera2LoadingIndicator.stopAnimating()
                self.videoConnectionState.backgroundColor = .green
            }
            
            // Your stream url should be here !
            //let url = URL(string: "http://192.168.178.75:81/stream")
            let url = URL(string: "http://10.0.0.74:81/stream")
            camera2Stream.contentURL = url
            camera2Stream.play() // Play the stream
            
        }else{
            camera2Stream.stop()
            camera2ImageView.image = nil
            self.camera2LoadingIndicator.stopAnimating()
            sender.setTitle("Start", for: .normal)
        }
        
    }
    @IBAction func actionZoomCamera2(_ sender: UIButton) {
        
        if camera2Height.constant == self.view.bounds.height {
            camera2Height.constant = camera2BasicHeight
        }else{
            camera1height.constant = camera1BasicHeight
            camera2Height.constant = self.view.bounds.height
            camera3Height.constant = camera3BasicHeight
            self.view.bringSubviewToFront(camera2ImageView)
            self.view.bringSubviewToFront(camera2StartButton)
            self.view.bringSubviewToFront(camera2Label)
            self.view.bringSubviewToFront(camera2LoadingIndicator)
            self.view.bringSubviewToFront(sender)
        }
        
        animateCameraScreen()
    }
    
    
    @IBAction func actionStartCamera3(_ sender: UIButton) {
        
        print("actionStartCamera3")
        
        if sender.title(for: .normal) == "Start" {
            
            sender.setTitle("", for: .normal)
            
            // Set the ImageView to the stream object
            camera3Stream = MJPEGStreamLib(imageView: camera3ImageView)
            // Start Loading Indicator
            camera3Stream.didStartLoading = { [unowned self] in
                self.camera3LoadingIndicator.startAnimating()
                self.videoConnectionState.backgroundColor = .orange
            }
            // Stop Loading Indicator
            camera3Stream.didFinishLoading = { [unowned self] in
                self.camera3LoadingIndicator.stopAnimating()
                self.videoConnectionState.backgroundColor = .green
                
            }
            
            // Your stream url should be here !
            //let url = URL(string: "http://192.168.178.55:8081/?action=stream")
            let url = URL(string: "http://10.0.0.85:8081/?action=stream")
            camera3Stream.contentURL = url
            camera3Stream.play() // Play the stream
            
        }else{
            camera3Stream.stop()
            camera3ImageView.image = nil
            self.camera3LoadingIndicator.stopAnimating()
            sender.setTitle("Start", for: .normal)
        }
        
    }
    @IBAction func actionZoomCamera3(_ sender: UIButton) {
        
        if camera3Height.constant == self.view.bounds.height {
            camera1height.constant = camera1BasicHeight
            camera2Height.constant = camera2BasicHeight
            camera3Height.constant = camera3BasicHeight
        }else{
            camera1height.constant = camera1BasicHeight - 106
            camera2Height.constant = camera2BasicHeight - 106
            camera3Height.constant = self.view.bounds.height
            self.view.bringSubviewToFront(camera3ImageView)
            self.view.bringSubviewToFront(camera3StartButton)
            self.view.bringSubviewToFront(camera3Label)
            self.view.bringSubviewToFront(camera3LoadingIndicator)
            self.view.bringSubviewToFront(sender)
        }
        
        animateCameraScreen()
    }
    func animateCameraScreen() {
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    var camera1BasicHeight: CGFloat { get {return 200} }
    var camera2BasicHeight: CGFloat { get {return 200} }
    var camera3BasicHeight: CGFloat { get {return 200} }
}
