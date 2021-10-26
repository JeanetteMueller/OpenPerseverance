//
//  SettingsVC.swift
//  rovercontrol
//
//  Created by Jeanette Müller on 25.10.21.
//

import UIKit
import JxContentTable
import JxThemeManager
import GameController

class SettingsVC: JxContentTableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Close", style: .done, target: self, action: #selector(self.close))
    }
    @objc func close() {
        self.navigationController?.dismiss(animated: true, completion: {
            
        })
    }
    override func prepareContent() {
        
        super.prepareContent()
        
        headlines.append("")
        var a = [ContentTableViewCellData]()
        a.append(DetailViewCell.SwitchCell(withTitle: "Development Environment",
                                           isOn: GlobalSettings.getEnvironment() == .Dev,
                                           andAction: { cell, indexpath, on in
            
            GlobalSettings.setEnvironment(on == true ? .Dev : .Normal)
            
        }))
        content.append(a)
        
        headlines.append("Calibration")
        var b = [ContentTableViewCellData]()
        
        b.append(DetailViewCell.StepperCell(withTitle: "Vorne links",
                                            withValue: Double(GlobalSettings.getCalibrationFrontLeft()),
                                            withMin: -90,
                                            withMax: 90,
                                            andStepsize: 0.5,
                                            andFormat: "%.1f", andAction: { cell, indexpath, value in
            GlobalSettings.setCalibrationFrontLeft(Float(value))
            self.updateCurrentWheelRotation()
            self.reload()
        }))
        b.append(DetailViewCell.StepperCell(withTitle: "Vorne rechts",
                                            withValue: Double(GlobalSettings.getCalibrationFrontRight()),
                                            withMin: -90,
                                            withMax: 90,
                                            andStepsize: 0.5,
                                            andFormat: "%.1f", andAction: { cell, indexpath, value in
            GlobalSettings.setCalibrationFrontRight(Float(value))
            self.updateCurrentWheelRotation()
            self.reload()
        }))
        b.append(DetailViewCell.StepperCell(withTitle: "Hinten links",
                                            withValue: Double(GlobalSettings.getCalibrationBackLeft()),
                                            withMin: -90,
                                            withMax: 90,
                                            andStepsize: 0.5,
                                            andFormat: "%.1f", andAction: { cell, indexpath, value in
            GlobalSettings.setCalibrationBackLeft(Float(value))
            self.updateCurrentWheelRotation()
            self.reload()
        }))
        b.append(DetailViewCell.StepperCell(withTitle: "Hinten rechts",
                                            withValue: Double(GlobalSettings.getCalibrationBackRight()),
                                            withMin: -90,
                                            withMax: 90,
                                            andStepsize: 0.5,
                                            andFormat: "%.1f", andAction: { cell, indexpath, value in
            GlobalSettings.setCalibrationBackRight(Float(value))
            self.updateCurrentWheelRotation()
            self.reload()
        }))
        
        content.append(b)
    }
    
    func updateCurrentWheelRotation() {
        
        if let mySceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate{
            if let r = mySceneDelegate.rover {
                
                r.driving = .Drive
            }
        }
//        let wr = Rover.WheelRotation(fl: Rover.maxSteerRadius, fr: self.maxSteerRadius,
//                                     bl: self.maxSteerRadius, br: self.maxSteerRadius)
//
//        self.topDownPositionView.updateWheelRotation(wr)
//
//        CommunicationManager.shared.sendWheelRotation(wr)
    }
}


