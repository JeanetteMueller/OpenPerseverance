//
//  MainVC+CameraActions.swift
//  rovercontrol
//
//  Created by Jeanette Müller on 24.06.21.
//

import UIKit
import MJPEGStreamLib

extension MainVC {
    
    enum CameraType {
        case Tower, Front
    }
    
    
    func animateCameraScreen() {
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    var camera1BasicHeight: CGFloat { get {return 270} }
    var camera2BasicHeight: CGFloat { get {return 270} }
    var camera3BasicHeight: CGFloat { get {return 270} }
    
    
    func getImageViewByCam(_ cam: CameraType) -> UIImageView {
        switch cam {
        case .Front:
            return self.camera1ImageView
        case .Tower:
            return self.camera3ImageView
        }
    }
    func takePhotoOfCamera(_ cam: CameraType) -> Bool{
        print("take photo \(cam)")
        
        let source = self.getImageViewByCam(cam)
        
        if let copy = source.image?.copy() as? UIImage {
            
            UIImageWriteToSavedPhotosAlbum(copy, nil, nil, nil)
            
            return true
        }
        return false
    }
    
    func savePhotoForCam(_ cam: CameraType, withButton sender:UIButton) {
        sender.setTitle("Saving", for: .normal)
        if self.takePhotoOfCamera(cam) {
            sender.setTitle("SAVED", for: .normal)
            let updateButton = sender
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                updateButton.setTitle("Photo", for: .normal)
            }
        }
    }
    @IBAction func actionPhotoCamera1(_ sender: UIButton) {
        self.savePhotoForCam(.Front, withButton: sender)
    }
    @IBAction func actionPhotoCamera3(_ sender: UIButton) {
        self.savePhotoForCam(.Tower, withButton: sender)
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
            
            camera1PhotoButton.isHidden = false
            
        }else{
            camera1Stream.stop()
            camera1ImageView.image = nil
            self.camera1LoadingIndicator.stopAnimating()
            sender.setTitle("Start", for: .normal)
            camera1PhotoButton.isHidden = true
        }
    }
    @IBAction func actionZoomCamera1(_ sender: UIButton) {
        
        if camera1Height.constant == self.view.bounds.height {
            camera1Height.constant = camera1BasicHeight
            camera1Height.priority = UILayoutPriority(rawValue: 1000)
            camera3Height.constant = camera3BasicHeight
            camera3Height.priority = UILayoutPriority(rawValue: 1000)
        }else{
            camera1Height.constant = self.view.bounds.height
            camera1Height.priority = UILayoutPriority(rawValue: 1000)
            camera3Height.constant = camera3BasicHeight
            camera3Height.priority = UILayoutPriority(rawValue: 800)
            self.view.bringSubviewToFront(cameraContainer1)
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
            camera3PhotoButton.isHidden = false
        }else{
            camera3Stream.stop()
            camera3ImageView.image = nil
            self.camera3LoadingIndicator.stopAnimating()
            sender.setTitle("Start", for: .normal)
            camera3PhotoButton.isHidden = true
        }
        
    }
    @IBAction func actionZoomCamera3(_ sender: UIButton) {
        
        if camera3Height.constant == self.view.bounds.height {
            camera1Height.constant = camera1BasicHeight
            camera1Height.priority = UILayoutPriority(rawValue: 1000)
            camera3Height.constant = camera3BasicHeight
            camera1Height.priority = UILayoutPriority(rawValue: 1000)
        }else{
            camera1Height.constant = camera1BasicHeight
            camera1Height.priority = UILayoutPriority(rawValue: 800)
            camera3Height.constant = self.view.bounds.height
            camera3Height.priority = UILayoutPriority(rawValue: 1000)
            self.view.bringSubviewToFront(cameraContainer3)
        }
        
        animateCameraScreen()
    }
}
