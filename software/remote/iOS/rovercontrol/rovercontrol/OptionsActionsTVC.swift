//
//  OptionsActionsTVC.swift
//  rovercontrol
//
//  Created by Jeanette Müller on 11.04.21.
//

import UIKit
import JxContentTable
import JxThemeManager


class OptionsActionsTVC: OptionsTVC {
    
    override func prepareContent() {
        super.prepareContent()
        
        headlines.append("")
        var c = [ContentTableViewCellData]()
        
        
        c.append(DetailViewCell.BasicCell(withTitle: "Destroy",  andAction: { (cell, path) in
            
            let d = Rover.HeadInformation(colorRed: 1, colorGreen: 0, colorBlue: 0)
            CommunicationManager.shared.sendHeadInformation(d)
            
            let s = Rover.SoundInformation(file: "Destroy.mp3", action: 0)
            
            CommunicationManager.shared.sendSoundInformation(s)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                let d = Rover.HeadInformation(colorRed: 0, colorGreen: 0, colorBlue: 0)
                CommunicationManager.shared.sendHeadInformation(d)
            }
            
            
            
        }))
        c.append(DetailViewCell.BasicCell(withTitle: "Action 2", andAction: { (cell, path) in
            
        }))

        
        content.append(c)
    }
}
