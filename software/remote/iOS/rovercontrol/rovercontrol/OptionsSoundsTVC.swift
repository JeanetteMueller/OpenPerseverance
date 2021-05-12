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
    
    override func prepareContent() {
        super.prepareContent()
        
        headlines.append("Sounds")
        var c = [ContentTableViewCellData]()
        
        
        var files = [
            "Arrest that robot.mp3",
            "Beeps 1.mp3",
            "Beeps 2.mp3",
            "Beeps 3.mp3",
            "citizen of the earth, you will be destroyed.mp3",
            "Countdown - 10, 9, 8.mp3",
            "Destroy.mp3",
            "Directive.mp3",
            "Distance to target.mp3",
            "Hahaha.mp3",
            "Identification please.mp3",
            "Ignition.mp3",
            "Lock on Target.mp3",
            "Override.mp3",
            "Self Destruct initiated.mp3",
            "Startup iMac.mp3",
            "System override.mp3",
            "Terminate.mp3",
            "Vocal Beeps 2.mp3",
            "Wall-E, No.mp3",
            "WALLE 1.mp3",
            "Whoa.mp3",
            "Rock Music.mp3",
            "Arrest that robot.mp3",
            "Beeps 1.mp3",
            "Beeps 2.mp3",
            "Beeps 3.mp3",
            "citizen of the earth, you will be destroyed.mp3",
            "Countdown - 10, 9, 8.mp3",
            "Destroy.mp3",
            "Directive.mp3",
            "Distance to target.mp3",
            "Hahaha.mp3",
            "Identification please.mp3",
            "Ignition.mp3"
        ]
        
        for file in files {
            c.append(DetailViewCell.BasicCell(withTitle: file,  andAction: { (cell, path) in
                //self.selectRow(at: path)
                
                let s = Rover.SoundInformation(file: file, action: 0)
                
                CommunicationManager.shared.sendSoundInformation(s)
                
            }))
        }
        
        
        content.append(c)
        
        headlines.append("Music")
        c = [ContentTableViewCellData]()
        
        
        files = [
            "Rock Music.mp3"
        ]
        
        for file in files {
            c.append(DetailViewCell.BasicCell(withTitle: file,  andAction: { (cell, path) in
                //self.selectRow(at: path)
                
                let s = Rover.SoundInformation(file: file, action: 0)
                
                CommunicationManager.shared.sendSoundInformation(s)
                
            }))
        }
        
        
        content.append(c)
    }
}
