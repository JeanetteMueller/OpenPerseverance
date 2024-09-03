//
//  OptionsSoundsTVC.swift
//  rovercontrol
//
//  Created by Jeanette Müller on 11.04.21.
//

import UIKit
import JxContentTable
import JxThemeManager


class OptionsSoundsTVC: OptionsTVC {
    
    static var soundFiles = [
        "Nr 5 - Arrest that robot.mp3",
        "Nr 5 - Malfunction.mp3",
        "Nr 5 - Robot alert.mp3",
        "Nr 5 - Software.mp3",
        "Nr 5 - What planet.mp3",
        "R2D2 - Beeps 1.mp3",
        "R2D2 - Beeps 2.mp3",
        "R2D2 - Vocal Beeps 2.mp3",
        "Robot - citizen of the earth, you will be destroyed.mp3",
        "Robot - Countdown - 10, 9, 8.mp3",
        "Robot - Destroy.mp3",
        "Robot - Distance to target.mp3",
        "Robot - Hahaha.mp3",
        "Robot - Identification please.mp3",
        "Robot - Ignition.mp3",
        "Robot - Lock on Target.mp3",
        "Robot - Override.mp3",
        "Robot - Self Destruct initiated.mp3",
        "Robot - System override.mp3",
        "Robot - Terminate.mp3",
        "Startup iMac.mp3",
        "Terminator - Ill be back.mp3",
        "Wall-E - 1.mp3",
        "Wall-E - Directive.mp3",
        "Wall-E - No.mp3",
        "Wall-E - Solar Charge and Boot.mp3",
        "Wall-E - Whoa.mp3",
    ]
    
    static var usualFiles = [
        "Nr 5 - Malfunction.mp3",
        "Nr 5 - Software.mp3",
        "R2D2 - Beeps 1.mp3",
        "R2D2 - Beeps 2.mp3",
        "R2D2 - Vocal Beeps 2.mp3",
        "Terminator - Ill be back.mp3",
        "Wall-E - 1.mp3",
        "Wall-E - Directive.mp3",
        "Wall-E - No.mp3",
    ]
    
    override func prepareContent() {
        super.prepareContent()
        
        headlines.append("Sounds")
        var c = [ContentTableViewCellData]()
        
        var files = OptionsSoundsTVC.soundFiles
        
        for file in files {
            c.append(DetailViewCell.BasicCell(withTitle: file,  andAction: { (cell, path) in
                //self.selectRow(at: path)
                
//                let s = Rover.SoundInformation(file: file, action: 0)
//                
//                CommunicationManager.shared.sendSoundInformation(s)
                
            }))
        }
        
        
        content.append(c)
        
        headlines.append("Music")
        c = [ContentTableViewCellData]()
        
        files = [
            "Rock Music.mp3",
        ]
        
        for file in files {
            
            var filetitle = file
            let suffix = ".mp3"
            
            if filetitle.hasSuffix(suffix) {
                filetitle = filetitle.subString(to: filetitle.length - suffix.length)
            }
            
            c.append(DetailViewCell.BasicCell(withTitle: filetitle,  andAction: { (cell, path) in
                //self.selectRow(at: path)
                
//                let s = Rover.SoundInformation(file: file, action: 0)
//                
//                CommunicationManager.shared.sendSoundInformation(s)
                
            }))
        }
        
        
        content.append(c)
    }
}
