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
        
        MovementManager.shared.addDelegate(self)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //self.tableView.selectRow(at: self.selectedIndexPath, animated: false, scrollPosition: .top)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        MovementManager.shared.addDelegate(self)

        self.tableView.selectRow(at: self.selectedIndexPath, animated: false, scrollPosition: .top)
        
    }
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.selectedIndexPath = indexPath
//        self.selectRow(at: self.selectedIndexPath)
//    }
    override func viewDidDisappear(_ animated: Bool) {
        repeatTimer?.invalidate()
        repeatTimer = nil
        MovementManager.shared.removeDelegate(self)
        
        super.viewDidDisappear(animated)
    }
    
    func selectRow(at indexPath: IndexPath){
        self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
    }
    
    
    var repeatTimer: Timer?
    var lastPressedDPad:MovementManager.ButtonType?
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.seactionHeadlineText(forSection: section)
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
            let numberOfSections = tableView.numberOfSections
            
            if button == .DpadDown{
                let oldSelectedPath = self.selectedIndexPath
                
                
                let numberOfRows = tableView.numberOfRows(inSection: oldSelectedPath.section)
                
                if oldSelectedPath.row < numberOfRows-1 {
                    self.tableView.deselectRow(at: oldSelectedPath, animated: true)
                    selectedIndexPath = IndexPath(row: oldSelectedPath.row + 1, section: oldSelectedPath.section)
                    
                    self.tableView.selectRow(at: selectedIndexPath, animated: true, scrollPosition: .middle)
                }else if numberOfSections - 1 > oldSelectedPath.section{
                    self.tableView.deselectRow(at: oldSelectedPath, animated: true)
                    
                    selectedIndexPath = IndexPath(row: 0, section: oldSelectedPath.section + 1)
                    
                    self.tableView.selectRow(at: selectedIndexPath, animated: true, scrollPosition: .middle)
                }else{
                    
                    selectedIndexPath = IndexPath(row: 0, section: 0)
                    self.tableView.selectRow(at: selectedIndexPath, animated: true, scrollPosition: .middle)
                }
            } else if button == .DpadUp {
                let oldSelectedPath = self.selectedIndexPath
                
                if oldSelectedPath.row > 0 {
                    self.tableView.deselectRow(at: oldSelectedPath, animated: true)
                    selectedIndexPath = IndexPath(row: oldSelectedPath.row - 1, section: oldSelectedPath.section)
                    
                    self.tableView.selectRow(at: selectedIndexPath, animated: true, scrollPosition: .middle)
                }else if oldSelectedPath.section > 0 {
                    self.tableView.deselectRow(at: oldSelectedPath, animated: true)
                    
                    let numberOfRows = tableView.numberOfRows(inSection: oldSelectedPath.section - 1)
                    
                    selectedIndexPath = IndexPath(row: numberOfRows - 1, section: oldSelectedPath.section - 1)
                    
                    self.tableView.selectRow(at: selectedIndexPath, animated: true, scrollPosition: .middle)
                }else{
                    
                    let numberOfRowsInSection = tableView.numberOfRows(inSection: numberOfSections - 1)
                    selectedIndexPath = IndexPath(row: numberOfRowsInSection - 1, section: numberOfSections - 1)
                    
                    self.tableView.selectRow(at: selectedIndexPath, animated: true, scrollPosition: .middle)
                }
            } else if button == .ButtonA || button == .DpadRight {
                
                self.tableView(self.tableView, didSelectRowAt: self.selectedIndexPath)
                self.selectRow(at: self.selectedIndexPath)
            }else if button == .ButtonX || button == .DpadLeft {
                if self.navigationController?.viewControllers.count ?? 0 > 1 {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
            if self.repeatTimer == nil {
                print("Start Repeat timer")
                self.lastPressedDPad = button
                self.repeatTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.startDpadRepeatTimer), userInfo: nil, repeats: false)
            }
        }else{
            if button == self.lastPressedDPad {
                self.lastPressedDPad = nil
                self.repeatTimer?.invalidate()
                self.repeatTimer = nil
            }
        }
    }
    @objc func startDpadRepeatTimer() {
        self.repeatTimer?.invalidate()
        self.repeatTimer = Timer.scheduledTimer(timeInterval: 0.15, target: self, selector: #selector(self.dPadRepeatTimerAction), userInfo: nil, repeats: true)
    }
    @objc func dPadRepeatTimerAction() {
        if let button = self.lastPressedDPad {
            self.inputManager(MovementManager.shared, button: button, isPressed: true, pressValue: nil)
        }
    }
    
    func inputManager(_ manager: MovementManager, thumbstick: MovementManager.ThumbstickType, x: Float, y: Float) {
        //
    }
    
    func inputManagerDidChanged(_ manager: MovementManager, withUpdate update: MovementManager.MovementManagerUpdate) {
        //
    }
    
    
}
