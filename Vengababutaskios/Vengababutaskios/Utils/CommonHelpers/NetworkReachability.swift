//
//  NetworkReachability.swift
//  Vengababutaskios
//
//  Created by Venga Babu on 28/11/24.
//

import Foundation
import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private var monitor: NWPathMonitor
    private var queue: DispatchQueue
    
    var isConnected: Bool = false
    var connectionType: String = "Unknown"
    
    private init() {
        monitor = NWPathMonitor()
        queue = DispatchQueue(label: "NetworkMonitorQueue")
    }
    
    // Start monitoring the network
    func startMonitoring() {
        monitor.start(queue: queue)
        
        monitor.pathUpdateHandler = { path in
            self.updateConnectionStatus(path: path)
        }
    }
    
    // Stop monitoring the network
    func stopMonitoring() {
        monitor.cancel()
    }
    
    // Update the network status based on the NWPath
    private func updateConnectionStatus(path: NWPath) {
        if path.status == .satisfied {
            self.isConnected = true
            self.connectionType = getConnectionType(path)
        } else {
            self.isConnected = false
            self.connectionType = "No Connection"
        }
        
        // Notify listeners or update UI
        DispatchQueue.main.async {
            // For example, update a label or show a message in the UI
            print("Connection Status: \(self.isConnected ? "Connected" : "Disconnected")")
            print("Connection Type: \(self.connectionType)")
        }
    }
    
    // Get the connection type (Wi-Fi, Cellular, or others)
    private func getConnectionType(_ path: NWPath) -> String {
        if path.usesInterfaceType(.wifi) {
            return "Wi-Fi"
        } else if path.usesInterfaceType(.cellular) {
            return "Cellular"
        } else if path.usesInterfaceType(.wiredEthernet) {
            return "Wired Ethernet"
        } else {
            return "Unknown"
        }
    }
}
