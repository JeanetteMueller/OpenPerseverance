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
    @IBOutlet weak var buttonSpeed: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    
    

    
    
    
    @IBOutlet weak var camera1Label: UILabel!
    @IBOutlet weak var camera1ImageView: UIImageView!
    @IBOutlet weak var camera1LoadingIndicator: UIActivityIndicatorView!
    var camera1Stream: MJPEGStreamLib!
    @IBOutlet weak var camera1StartButton: UIButton!
    @IBOutlet weak var camera1ZoomButton: UIButton!
    @IBOutlet weak var camera1height: NSLayoutConstraint!
    
    
    @IBOutlet weak var camera2Label: UILabel!
    @IBOutlet weak var camera2ImageView: UIImageView!
    @IBOutlet weak var camera2LoadingIndicator: UIActivityIndicatorView!
    var camera2Stream: MJPEGStreamLib!
    @IBOutlet weak var camera2StartButton: UIButton!
    @IBOutlet weak var camera2ZoomButton: UIButton!
    @IBOutlet weak var camera2Height: NSLayoutConstraint!
    
    
    @IBOutlet weak var camera3Label: UILabel!
    @IBOutlet weak var camera3ImageView: UIImageView!
    @IBOutlet weak var camera3LoadingIndicator: UIActivityIndicatorView!
    var camera3Stream: MJPEGStreamLib!
    @IBOutlet weak var camera3StartButton: UIButton!
    @IBOutlet weak var camera3ZoomButton: UIButton!
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
        
        self.camera2ImageView.layer.borderColor = UIColor.lightGray.cgColor
        self.camera2ImageView.layer.borderWidth = 1
        
        self.camera3ImageView.layer.borderColor = UIColor.lightGray.cgColor
        self.camera3ImageView.layer.borderWidth = 1
        
        CommunicationManager.shared.delegate = self
        
        MovementManager.shared.addDelegate(self)
        
        
        
    }
    func updateButtons() {
        for b in [buttonDriveMode,
                  buttonLights,
                  buttonSpeed] {
            
            b?.isEnabled = true
            b?.backgroundColor = .white
                
        }
        
        buttonPause.backgroundColor = .red
        buttonPause.setTitleColor(.white, for: .normal)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setActionButtonStyle([buttonPause,
                                   buttonDriveMode,
                                   buttonLights,
                                   buttonSpeed
                                   ])
        
        
        

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
        
        
        camera1height.constant = camera1BasicHeight
        camera2Height.constant = camera2BasicHeight
        camera3Height.constant = camera3BasicHeight
        self.view.layoutIfNeeded()
        
        
        if let mySceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate{
            if let r = mySceneDelegate.rover {
                
                self.roverTopDownView = r.topDownPositionView
                self.roverTopDownView!.center = CGPoint(x: self.roverTopDownContainerView.frame.size.width / 2,
                                                        y: self.roverTopDownContainerView.frame.size.height / 2)
                let scale:CGFloat = 1.0
                
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
