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
        
        
        c.append(DetailViewCell.BasicCell(withTitle: "Action 1",  andAction: { (cell, path) in
            //self.selectRow(at: path)
            
            
        }))
        c.append(DetailViewCell.BasicCell(withTitle: "Action 2", andAction: { (cell, path) in
            
        }))

        
        content.append(c)
    }
}
