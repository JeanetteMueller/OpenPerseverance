//
//  OptionsRootTVC.swift
//  rovercontrol
//
//  Created by Jeanette Müller on 11.04.21.
//

import UIKit
import JxContentTable
import JxThemeManager


class OptionsRootTVC: OptionsTVC {
    
    override func prepareContent() {
        super.prepareContent()
        
        headlines.append("")
        var c = [ContentTableViewCellData]()
        
        
        
        c.append(DetailViewCell.BasicCell(withTitle: "options settings".localized, andImage: UIImage(named: "19-gear"), andAction: { (cell, path) in
            self.performSegue(withIdentifier: "SettingsVC", sender: nil)
        }))
        
        
        content.append(c)
    }
}
