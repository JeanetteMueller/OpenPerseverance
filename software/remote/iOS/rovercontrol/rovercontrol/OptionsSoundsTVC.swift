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
        
        headlines.append("")
        var c = [ContentTableViewCellData]()
        
        
        c.append(DetailViewCell.BasicCell(withTitle: "Sound 1",  andAction: { (cell, path) in
            //self.selectRow(at: path)
            
            
        }))
        c.append(DetailViewCell.BasicCell(withTitle: "Sound 2", andAction: { (cell, path) in
            
        }))
        
        
        content.append(c)
    }
}
