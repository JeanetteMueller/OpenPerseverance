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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "19-gear"),
                                                                 style: .done,
                                                                 target: self,
                                                                 action: #selector(self.showSettings(_:)))
    }
    @objc func showSettings(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "SettingsVC", sender: sender)
    }
    override func prepareContent() {
        super.prepareContent()
        
        headlines.append("")
        var c = [ContentTableViewCellData]()
        
        
        
        c.append(DetailViewCell.BasicCell(withTitle: "options sounds".localized, andAction: { (cell, path) in
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "OptionsSoundsTVC") as? OptionsSoundsTVC {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }))
        
        c.append(DetailViewCell.BasicCell(withTitle: "options lights".localized, andAction: { (cell, path) in
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "OptionsLightsTVC") as? OptionsLightsTVC {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }))
        
        c.append(DetailViewCell.BasicCell(withTitle: "options actions".localized,  andAction: { (cell, path) in
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "OptionsActionsTVC") as? OptionsActionsTVC {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }))
        
        content.append(c)
    }
}
