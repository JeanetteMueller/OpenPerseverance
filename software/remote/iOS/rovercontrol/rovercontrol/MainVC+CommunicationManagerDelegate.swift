//
//  MainVC+CommunicationManagerDelegate.swift
//  rovercontrol
//
//  Created by Jeanette Müller on 30.03.21.
//

import Foundation

extension MainVC: CommunicationManagerDelegate {
    func communicationManager(_ m: CommunicationManager, didChange state: CommunicationManager.State) {
        
        DispatchQueue.main.async {
            switch state {
                case .Connected:
                print("MainVC State: Ready")
                self.robotConnectionState.backgroundColor = .green
                self.updateButtons()
            case .Setup:
                print("MainVC State: Setup")
                self.robotConnectionState.backgroundColor = .cyan
            case .Cancelled:
                print("MainVC State: Cancelled")
                self.robotConnectionState.backgroundColor = .darkGray
                self.updateButtons()
            case .Connecting:
                print("MainVC State: Preparing")
                self.robotConnectionState.backgroundColor = .yellow
            case .Failed:
                print("MainVC State: Failed")
                self.robotConnectionState.backgroundColor = .red
                self.updateButtons()
            default:
                print("MainVC State: not defined!\n")
                self.robotConnectionState.backgroundColor = .red
                self.updateButtons()
            }
        }
    }
    
    func communicationManager(_ m: CommunicationManager, didReceive data: Data, fromClient client:UDPClient) {
        
        DispatchQueue.main.async {
            if let result = String(data: data, encoding: .utf8) {
                
                print("didReceive \(result)")
                
                self.statusLabel.text = "\(Date()): \(result)"
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                print("didReceive \(json)")
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            print("")
        }
        
    }
}
