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
        
        
        
        c.append(DetailViewCell.BasicCell(withTitle: "Sounds", andAction: { (cell, path) in
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "OptionsSoundsTVC") as? OptionsSoundsTVC {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }))
        
        c.append(DetailViewCell.BasicCell(withTitle: "Lights", andAction: { (cell, path) in
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "OptionsLightsTVC") as? OptionsLightsTVC {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }))
        
        c.append(DetailViewCell.BasicCell(withTitle: "Actions",  andAction: { (cell, path) in
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "OptionsActionsTVC") as? OptionsActionsTVC {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }))
        
        content.append(c)
    }
}
