//
//  ViewController.swift
//  rovercontrol
//
//  Created by Jeanette Müller on 19.03.21.
//

import UIKit
import GameController
import MJPEGStreamLib

class MainVC: UIViewController {
    
    @IBOutlet weak var stateContainer: UIView!
    @IBOutlet weak var robotConnectionState: UIView!
    @IBOutlet weak var videoConnectionState: UIView!
    @IBOutlet weak var gamePadConnectionState: UIView!
    
    @IBOutlet weak var optionsContainer: UIView!
    
    @IBOutlet weak var pauseOverlayView: UIView!
    @IBOutlet weak var buttonPause: UIButton!
    @IBOutlet weak var buttonUnpause: UIButton!
    
    
    @IBOutlet weak var buttonDriveMode: UIButton!
    @IBOutlet weak var buttonLights: UIButton!
    @IBOutlet weak var buttonSound: UIButton!
    @IBOutlet weak var buttonSpeed: UIButton!
    @IBOutlet weak var buttonTower: UIButton!
    @IBOutlet weak var buttonPower: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    @IBOutlet weak var camera1Label: UILabel!
    @IBOutlet weak var camera1ImageView: UIImageView!
    @IBOutlet weak var camera1LoadingIndicator: UIActivityIndicatorView!
    var camera1Stream: MJPEGStreamLib!
    @IBOutlet weak var camera1StartButton: UIButton!
    
    @IBOutlet weak var camera2Label: UILabel!
    @IBOutlet weak var camera2ImageView: UIImageView!
    @IBOutlet weak var camera2LoadingIndicator: UIActivityIndicatorView!
    var camera2Stream: MJPEGStreamLib!
    @IBOutlet weak var camera2StartButton: UIButton!
    
    @IBOutlet weak var roverTopDownContainerView: UIView!
    var roverTopDownView: RoverTopDownPositionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.statusLabel.text = "START"
        
        
        
        self.stateContainer.layer.cornerRadius = 15
        self.stateContainer.backgroundColor = .black
        self.stateContainer.layer.borderColor = UIColor.lightGray.cgColor
        self.stateContainer.layer.borderWidth = 1
        
        self.robotConnectionState.backgroundColor = .red
        self.robotConnectionState.layer.cornerRadius = 5
        
        self.videoConnectionState.backgroundColor = .red
        self.videoConnectionState.layer.cornerRadius = 5
        
        self.gamePadConnectionState.backgroundColor = .red
        self.gamePadConnectionState.layer.cornerRadius = 5
        
        
        self.camera1ImageView.layer.borderColor = UIColor.lightGray.cgColor
        self.camera1ImageView.layer.borderWidth = 1
        
        self.camera2ImageView.layer.borderColor = UIColor.lightGray.cgColor
        self.camera2ImageView.layer.borderWidth = 1
        
        CommunicationManager.shared.delegate = self
        
        MovementManager.shared.addDelegate(self)
        
        
        
    }
    func updateButtons() {
        
        if CommunicationManager.shared.state == .Connected, MovementManager.shared.state == .Connected {
                
                buttonDriveMode.isEnabled = true
                buttonLights.isEnabled = true
//                buttonSound.isEnabled = true
                buttonSpeed.isEnabled = true
            buttonTower.isEnabled = true
            buttonPower.isEnabled = true
                
        }else{
            buttonDriveMode.isEnabled = false
            buttonLights.isEnabled = false
            //                buttonSound.isEnabled = false
            buttonSpeed.isEnabled = false
            buttonTower.isEnabled = false
            buttonPower.isEnabled = false
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setActionButtonStyle([buttonDriveMode,
                                   buttonLights,
                                   buttonSound,
                                   buttonSpeed,
                                   buttonTower,
                                   buttonPower])
        
        self.optionsContainer.layer.borderWidth = 1.0
        self.optionsContainer.layer.borderColor = UIColor.darkGray.cgColor
        
        

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.notificationRoverStateChanges(_:)),
                                               name: .RoverStateChanges,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.notificationRoverDriveModeChanges(_:)),
                                               name: .RoverDriveModeChanges,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.notificationRoverSpeedModeChanges(_:)),
                                               name: .RoverSpeedModeChanges,
                                               object: nil)
        
        
        //udpTestSend()
        
        
        if let mySceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate{
            if let r = mySceneDelegate.rover {
                
                self.roverTopDownView = r.topDownPositionView
                self.roverTopDownView!.center = CGPoint(x: self.roverTopDownContainerView.frame.size.width / 2, y: self.roverTopDownContainerView.frame.size.height / 2)
                self.roverTopDownView!.transform = CGAffineTransform(scaleX: 2, y: 2)
                self.roverTopDownContainerView.addSubview(self.roverTopDownView!)
            }
        }
        
        updateRoverData()
        
        
    }
    func showOptionsOverlay() {
        self.optionsContainer.isHidden = false
        
        if let mySceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate{
            if let r = mySceneDelegate.rover {
                r.pause = !self.optionsContainer.isHidden
            }
        }
    }
    func hideOptionsOverlay() {
        
        self.optionsContainer.isHidden = true
        
        if let mySceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate{
            if let r = mySceneDelegate.rover {
                r.pause = !self.optionsContainer.isHidden
            }
        }
    }
    func updateAppearance() {
        
    }
    func setActionButtonStyle(_ buttons:[UIButton]) {
        
        for b in buttons {
            b.backgroundColor = .black
            b.layer.borderWidth = 1.0
            b.layer.borderColor = UIColor.darkGray.cgColor
        }
        
    }
    func updateRoverData(){
        
        if let ip = String.getIPAddress() {
            self.statusLabel.text = "IPAddress: \(ip)\n"
        }
        
        if let mySceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate{
            
            if let rover = mySceneDelegate.rover {
                self.statusLabel.text?.append(rover.getStatus())
                
                self.buttonDriveMode.isSelected = rover.driving == .Rotate
                
                self.buttonSpeed.isSelected = rover.speed == .Slow

            }else{
                self.statusLabel.text?.append("No Rover")
            }
            
        }
    }
    @objc func notificationRoverStateChanges(_ n:Notification) {
//        if let rover = n.object as? Rover{
//            self.statusLabel.text = rover.getStatus()
//        }
        updateRoverData()
    }
    @objc func notificationRoverDriveModeChanges(_ n:Notification) {
        updateRoverData()
        
    }
    @objc func notificationRoverSpeedModeChanges(_ n:Notification) {
        updateRoverData()
        
    }
    
    var testValue: Float = 0
    var moveUp = true
    var wait: Double = 0
    
}
