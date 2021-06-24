//
//  UDPClient.swift
//  tachikomacontrol
//
//  Created by Jeanette Müller on 28.09.20.
//  Copyright © 2020 Jeanette Müller. All rights reserved.
//

import Network
//import NetworkExtension
import Foundation

protocol UDPClientDelegate {
    func udpClient(_ client: UDPClient, didReceive data: Data)
    func udpClient(_ client: UDPClient, didChange state: NWConnection.State)
}
class UDPClient {
    
    var connection: NWConnection
    var address: NWEndpoint.Host
    var port: NWEndpoint.Port
    var delegate: UDPClientDelegate?
    private var listening = true
    var isListening: Bool {
        get {
            return listening
        }
    }
    
    var resultHandler = NWConnection.SendCompletion.contentProcessed { NWError in
        guard NWError == nil else {
            print("ERROR! Error when data (Type: Data) sending. NWError: \n \(NWError!)")
            return
        }
    }
    var state: NWConnection.State = .setup {
        didSet {
            self.delegate?.udpClient(self, didChange: self.state)
        }
    }
    
    init?(address newAddress: String, port newPort: Int32, listener isListener: Bool = true) {
        guard let codedAddress = IPv4Address(newAddress),
              let codedPort = NWEndpoint.Port(rawValue: NWEndpoint.Port.RawValue(newPort)) else {
            print("Failed to create connection address")
            return nil
        }
        address = .ipv4(codedAddress)
        port = codedPort
        listening = isListener
        
        connection = NWConnection(host: address, port: port, using: .udp)
        
        connect()
    }
    
    func connect() {
        connection.stateUpdateHandler = { newState in
            print("stateUpdateHandler")
            self.state = newState
            
            switch (newState) {
                case .ready:
                    print("State: Ready")
                    if self.listening { self.listen() }
                case .setup:
                    print("State: Setup")
                case .cancelled:
                    print("State: Cancelled")
                    
                case .preparing:
                    print("State: Preparing")
                default:
                    print("ERROR! State not defined!\n")
            }
            
            
        }
        connection.start(queue: .global())
    }
    
    func send(_ data: Data) {
        connection.send(content: data, completion: resultHandler)
    }
    
    private func listen() {
        
        if self.listening {
            self.connection.receiveMessage { data, context, isComplete, error in
                if isComplete {
                    print("Receive isComplete: " + isComplete.description)
                    guard let data = data else {
                        //print("Error: Received nil Data")
                        return
                    }
                    print("Data Received")
                    
                    self.delegate?.udpClient(self, didReceive: data)
                }
                
            }
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.20) {
                self.listen()
            }
        }
        
    }
    func disconnect() {
        
        self.connection.cancel()
        self.connection.cancelCurrentEndpoint()
        
    }
}
