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
        
        headlines.append("")
        var c = [ContentTableViewCellData]()
        
        
        c.append(DetailViewCell.BasicCell(withTitle: "Licht 1",  andAction: { (cell, path) in
            //self.selectRow(at: path)
            

        }))
        c.append(DetailViewCell.BasicCell(withTitle: "Licht 2", andAction: { (cell, path) in

        }))
        c.append(DetailViewCell.BasicCell(withTitle: "Licht 3", andAction: { (cell, path) in

        }))
        c.append(DetailViewCell.BasicCell(withTitle: "Licht 4", andAction: { (cell, path) in
            
        }))
        c.append(DetailViewCell.BasicCell(withTitle: "Licht 5", andAction: { (cell, path) in
            
        }))
        
        content.append(c)
    }
}
