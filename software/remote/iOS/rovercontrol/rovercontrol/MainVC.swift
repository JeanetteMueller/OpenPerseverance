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
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBOutlet weak var stateContainer: UIView!
    @IBOutlet weak var robotConnectionState: UIView!
    @IBOutlet weak var videoConnectionState: UIView!
    @IBOutlet weak var gamePadConnectionState: UIView!
    
    @IBOutlet weak var optionsContainer: UIView!
    
    @IBOutlet weak var pauseOverlayView: UIView!
    @IBOutlet weak var buttonPause: UIButton!
    @IBOutlet weak var buttonUnpause: UIButton!
    
    
    @IBOutlet weak var buttonDriveMode: UIButton!
    @IBOutlet weak var buttonSpeed: UIButton!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var buttonLightRed: UIButton!
    @IBOutlet weak var buttonLightGreen: UIButton!
    @IBOutlet weak var buttonLightBlue: UIButton!
    @IBOutlet weak var buttonLaser: UIButton!
    

    @IBOutlet weak var cameraContainer1: UIView!
    @IBOutlet weak var cameraContainer2: UIView!
    @IBOutlet weak var cameraContainer3: UIView!
    
    @IBOutlet weak var camera1Label: UILabel!
    @IBOutlet weak var camera1ImageView: UIImageView!
    @IBOutlet weak var camera1LoadingIndicator: UIActivityIndicatorView!
    var camera1Stream: MJPEGStreamLib!
    @IBOutlet weak var camera1StartButton: UIButton!
    @IBOutlet weak var camera1ZoomButton: UIButton!
    @IBOutlet weak var camera1PhotoButton: UIButton!
    @IBOutlet weak var camera1Height: NSLayoutConstraint!
    
    
    @IBOutlet weak var camera3Label: UILabel!
    @IBOutlet weak var camera3ImageView: UIImageView!
    @IBOutlet weak var camera3LoadingIndicator: UIActivityIndicatorView!
    var camera3Stream: MJPEGStreamLib!
    @IBOutlet weak var camera3StartButton: UIButton!
    @IBOutlet weak var camera3ZoomButton: UIButton!
    @IBOutlet weak var camera3PhotoButton: UIButton!
    @IBOutlet weak var camera3Height: NSLayoutConstraint!
    
    
    @IBOutlet weak var roverTopDownContainerView: UIView!
    var roverTopDownView: RoverTopDownPositionView?
    
    @IBOutlet weak var roverSpeedContainerView: UIView?
    var roverSpeedView: RoverSpeedView?
    
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
        
        self.camera3ImageView.layer.borderColor = UIColor.lightGray.cgColor
        self.camera3ImageView.layer.borderWidth = 1
        
        CommunicationManager.shared.delegate = self
        
        MovementManager.shared.addDelegate(self)
        
        
        updateCameraButtons()
        
        
        self.nameLabel.text = self.systemInfo()
        
    }
    func systemInfo(_ format: String = "%@\nVersion %@\nBuild %@") -> String {
        
        if let bundleDict = Bundle.main.infoDictionary {
            var name = ""
            var shortVersion = ""
            var version = ""
            
            if let x = bundleDict["CFBundleDisplayName"] as? String {
                name = x
            }
            if let x = bundleDict["CFBundleShortVersionString"] as? String {
                shortVersion = x
            }
            if let x = bundleDict["CFBundleVersion"] as? String {
                version = x
            }
            
            return String(format: format,
                          name,
                          shortVersion,
                          version
                          
            )
        }
        return "SOMETHING WENT WRONG!"
    }
    func updateButtons() {
        for b in [buttonDriveMode,
                  buttonSpeed,
                  buttonLightRed,
                  buttonLightGreen,
                  buttonLightBlue,
                  buttonLaser] {
            
            b?.isEnabled = true
            b?.backgroundColor = .white
                
        }
        if buttonLightRed.isSelected {
            buttonLightRed.backgroundColor = .red
            buttonLightRed.setTitleColor(.white, for: .normal)
        }else{
            buttonLightRed.setTitleColor(.red, for: .normal)
            buttonLightRed.backgroundColor = .white
        }
        
        if buttonLightGreen.isSelected {
            buttonLightGreen.backgroundColor = .green
            buttonLightGreen.setTitleColor(.white, for: .normal)
        }else{
            buttonLightGreen.setTitleColor(.green, for: .normal)
            buttonLightGreen.backgroundColor = .white
        }
        
        if buttonLightBlue.isSelected {
            buttonLightBlue.backgroundColor = .blue
            buttonLightBlue.setTitleColor(.white, for: .normal)
        }else{
            buttonLightBlue.setTitleColor(.blue, for: .normal)
            buttonLightBlue.backgroundColor = .white
        }
        
        
        if buttonLaser.isSelected {
            buttonLaser.backgroundColor = .red
            buttonLaser.setTitleColor(.white, for: .normal)
        }else{
            buttonLaser.setTitleColor(.red, for: .normal)
            buttonLaser.backgroundColor = .white
        }
        
        
        buttonPause.backgroundColor = .red
        buttonPause.setTitleColor(.white, for: .normal)
    }
    func updateCameraButtons() {
        for b in [camera1StartButton, camera1ZoomButton, camera1PhotoButton,
                  camera3StartButton, camera3ZoomButton, camera3PhotoButton] {
        
            b?.setTitleColor(.white, for: .normal)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setActionButtonStyle([buttonPause,
                                   buttonDriveMode,
                                   buttonSpeed,
                                   buttonLightRed,
                                   buttonLightGreen,
                                   buttonLightBlue,
                                   buttonLaser])
        
        
        

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
        
        
        camera1Height.constant = camera1BasicHeight
        camera3Height.constant = camera3BasicHeight
        self.view.layoutIfNeeded()
        
        
        if let mySceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate{
            if let r = mySceneDelegate.rover {
                
                self.roverTopDownView = r.topDownPositionView
                self.roverTopDownView!.center = CGPoint(x: self.roverTopDownContainerView.frame.size.width / 2,
                                                        y: self.roverTopDownContainerView.frame.size.height / 2)
                let scale:CGFloat = 1.3
                
                self.roverTopDownView!.transform = CGAffineTransform(scaleX: scale, y: scale)
                self.roverTopDownContainerView.addSubview(self.roverTopDownView!)
                
                
                self.roverSpeedView = r.speedView
                self.roverSpeedView!.center = CGPoint(x: (self.roverSpeedContainerView?.frame.size.width ?? 2) / 2,
                                                      y: (self.roverSpeedContainerView?.frame.size.height ?? 2) / 2)
                self.roverSpeedContainerView?.addSubview(self.roverSpeedView!)
                
                
                self.view.bringSubviewToFront(self.optionsContainer)
            }
        }
        
        //self.camera3ImageView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
        
        updateRoverData()
        
        self.infoTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.loadRoverInfo), userInfo: nil, repeats: true)
    }
    var infoTimer: Timer?
    

    
    
    @objc func loadRoverInfo() {
        
        //CommunicationManager.shared.sendInfoInformation()
    }
    
    func showOptionsOverlay() {
        self.optionsContainer.isHidden = false
        self.view.bringSubviewToFront(self.optionsContainer)
        
        self.optionsContainer.layer.borderWidth = 1.0
        self.optionsContainer.layer.borderColor = UIColor.lightGray.cgColor
        
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
            b.backgroundColor = .white
            b.setTitleColor(.black, for: .normal)
            b.setTitleColor(.darkGray, for: .disabled)
            b.tintColor = .black
            b.layer.cornerRadius = 10
            
            b.imageView?.contentMode = .scaleAspectFit

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
                
                
                switch rover.speed {
                case .Normal:
                    self.buttonSpeed.setImage(UIImage(named: "speed_normal"), for: .normal)
                case .Fast:
                    self.buttonSpeed.setImage(UIImage(named: "speed_fast"), for: .normal)
                default:
                    self.buttonSpeed.setImage(UIImage(named: "speed_slow"), for: .normal)
                }

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
