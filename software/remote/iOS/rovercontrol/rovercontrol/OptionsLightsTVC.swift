//
//  OptionsLightsTVC.swift
//  rovercontrol
//
//  Created by Jeanette Müller on 11.04.21.
//

import UIKit
import JxContentTable
import JxThemeManager


class OptionsLightsTVC: OptionsTVC {
    
    override func prepareContent() {
        super.prepareContent()
        
        headlines.append("Tower")
        var c = [ContentTableViewCellData]()
        
//        c.append(DetailViewCell.BasicCell(withTitle: "Off", andAction: { (cell, path) in
//            //self.selectRow(at: path)
//            
//            let d = Rover.HeadInformation(colorRed: 0, colorGreen: 0, colorBlue: 0)
//            
//            CommunicationManager.shared.sendHeadInformation(d)
//        }))
//        c.append(DetailViewCell.BasicCell(withTitle: "Red", andTextColor: UIColor.red, andAction: { (cell, path) in
//            //self.selectRow(at: path)
//            
//            let d = Rover.HeadInformation(colorRed: 1, colorGreen: 0, colorBlue: 0)
//            
//            CommunicationManager.shared.sendHeadInformation(d)
//        }))
//        c.append(DetailViewCell.BasicCell(withTitle: "Green", andTextColor: UIColor.green, andAction: { (cell, path) in
//            //self.selectRow(at: path)
//            
//            let d = Rover.HeadInformation(colorRed: 0, colorGreen: 1, colorBlue: 0)
//            
//            CommunicationManager.shared.sendHeadInformation(d)
//        }))
//        c.append(DetailViewCell.BasicCell(withTitle: "Blue", andTextColor: UIColor.blue, andAction: { (cell, path) in
//            //self.selectRow(at: path)
//            
//            let d = Rover.HeadInformation(colorRed: 0, colorGreen: 0, colorBlue: 1)
//            
//            CommunicationManager.shared.sendHeadInformation(d)
//            
//        }))
        
        content.append(c)
        
        
        c = [ContentTableViewCellData]()
        headlines.append("Body")
        c.append(DetailViewCell.BasicCell(withTitle: "Light 1", andAction: { (cell, path) in

        }))
        c.append(DetailViewCell.BasicCell(withTitle: "Light 2", andAction: { (cell, path) in

        }))
        
        content.append(c)
    }
    

}
