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
                print("State: Ready")
                self.robotConnectionState.backgroundColor = .green
                self.updateButtons()
            case .Preparing:
                print("State: Setup")
                self.robotConnectionState.backgroundColor = .red
            case .Cancelled:
                print("State: Cancelled")
                self.robotConnectionState.backgroundColor = .darkGray
            case .Connecting:
                print("State: Preparing")
                self.robotConnectionState.backgroundColor = .yellow
            default:
                print("ERROR! State not defined!\n")
                self.robotConnectionState.backgroundColor = .red
            }
        }
    }
    
    func communicationManager(_ m: CommunicationManager, didReceive data: Data, fromClient client:UDPClient) {
        
        DispatchQueue.main.async {
            if let result = String(data: data, encoding: .utf8) {
                
                print("didReceive \(result)")
                
                self.statusLabel.text?.append("\n\(result)")
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
