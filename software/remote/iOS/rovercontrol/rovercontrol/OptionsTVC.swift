//
//  OptionsTVC.swift
//  rovercontrol
//
//  Created by Jeanette Müller on 11.04.21.
//

import UIKit
import JxContentTable
import JxThemeManager
import GameController

class OptionsTVC: JxContentTableViewController {
    
    var selectedIndexPath = IndexPath(row: 0, section: 0)
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //self.tableView.selectRow(at: self.selectedIndexPath, animated: false, scrollPosition: .top)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.tableView.selectRow(at: self.selectedIndexPath, animated: false, scrollPosition: .top)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        MovementManager.shared.addDelegate(self)

        //self.tableView.selectRow(at: self.selectedIndexPath, animated: false, scrollPosition: .top)
        
    }
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.selectedIndexPath = indexPath
//        self.selectRow(at: self.selectedIndexPath)
//    }
    override func viewDidDisappear(_ animated: Bool) {
        
        MovementManager.shared.removeDelegate(self)
        
        super.viewDidDisappear(animated)
    }
    
    func selectRow(at indexPath: IndexPath){
        self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
    }
}

extension OptionsTVC: MovementManagerDelegate {
    var movementManagerDelegateIdentifier: String {
        "OptionsTVC"
    }
    
    func inputManager(_ manager: MovementManager, didConnect controller: GCController) {
        //
    }
    
    func inputManager(_ manager: MovementManager, didDisconnect controller: GCController) {
        //
    }
    
    func inputManager(_ manager: MovementManager, button: MovementManager.ButtonType, isPressed pressed: Bool, pressValue value: Float?) {
        
        if pressed {
            if button == .DpadDown{
                let oldSelectedPath = self.selectedIndexPath
                
                let numberOfRows = tableView.numberOfRows(inSection: oldSelectedPath.section)
                
                if oldSelectedPath.row < numberOfRows-1 {
                    self.tableView.deselectRow(at: oldSelectedPath, animated: true)
                    selectedIndexPath = IndexPath(row: oldSelectedPath.row + 1, section: oldSelectedPath.section)
                    
                    self.tableView.selectRow(at: selectedIndexPath, animated: true, scrollPosition: .middle)
                }
            } else if button == .DpadUp {
                let oldSelectedPath = self.selectedIndexPath
                
                if oldSelectedPath.row > 0 {
                    self.tableView.deselectRow(at: oldSelectedPath, animated: true)
                    selectedIndexPath = IndexPath(row: oldSelectedPath.row - 1, section: oldSelectedPath.section)
                    
                    self.tableView.selectRow(at: selectedIndexPath, animated: true, scrollPosition: .middle)
                }
            } else if button == .ButtonA || button == .DpadRight {
                
                self.tableView(self.tableView, didSelectRowAt: self.selectedIndexPath)
                self.selectRow(at: self.selectedIndexPath)
            }else if button == .ButtonB || button == .DpadLeft {
                if self.navigationController?.viewControllers.count ?? 0 > 1 {
                    self.navigationController?.popViewController(animated: true)
                }else{
                    if let root = self.view.window?.rootViewController as? MainVC {
                        root.hideOptionsOverlay()
                    }
                }
            } else if button == .ButtonX {
                self.navigationController?.popToRootViewController(animated: false)
            }
        }
        
    }
    
    func inputManager(_ manager: MovementManager, thumbstick: MovementManager.ThumbstickType, x: Float, y: Float) {
        //
    }
    
    func inputManagerDidChanged(_ manager: MovementManager, withUpdate update: MovementManager.MovementManagerUpdate) {
        //
    }
    
    
}
