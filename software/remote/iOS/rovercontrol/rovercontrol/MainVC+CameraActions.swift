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
        case Tower
    }
    
    func animateCameraScreen() {
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    var camera1BasicHeight: CGFloat { get {return 180} }
    var camera3BasicHeight: CGFloat { get {return 180} }
    
    func getImageViewByCam(_ cam: CameraType) -> UIImageView {
        switch cam {
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
    
    @IBAction func actionPhotoCamera3(_ sender: UIButton) {
        self.savePhotoForCam(.Tower, withButton: sender)
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
            }
            // Stop Loading Indicator
            camera3Stream.didFinishLoading = { [unowned self] in
                self.camera3LoadingIndicator.stopAnimating()
                
            }
            
            // Your stream url should be here !
            
            // MUSS WAS NEUES mit 192.168.50.??? sein
            
            let url = URL(string: "http://\(CommunicationManager.shared.towerCameraIpAdress):8080/stream/video.mjpeg")
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
}
