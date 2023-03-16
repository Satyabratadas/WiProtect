//
//  NetworkMonitor.swift
//  WPA_Poc
//
//  Created by Satyabrata Das on 14/03/23.

import Foundation
import UIKit
import NetworkExtension


@available(iOS 15.0, *)
class NetworkManager: NSObject{
    let reachability = try! Reachability()
    var connectionAvailable = Bool()
    var completion: ((Bool)->Void)? = nil
    
    
    static let sharedInstance: NetworkManager = {
        return NetworkManager()
    }()
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        switch reachability.connection {
        case .wifi:
            self.connectionAvailable = true
            self.completion?(true)
            print("Reachable via WiFi")

        case .cellular:
            self.connectionAvailable = true
            self.completion?(true)
            print("Reachable via Cellular")
        case .unavailable:
            self.connectionAvailable = false
            self.completion?(false)
            print("Network not reachable")
        }
    }
    
    // Network is reachable
    static func isReachable(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.sharedInstance.reachability).connection != .unavailable {
            completed(NetworkManager.sharedInstance)
        }
    }
    
    // Network is unreachable
    static func isUnreachable(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.sharedInstance.reachability).connection == .unavailable {            completed(NetworkManager.sharedInstance)
        }
    }
    
    // Network is reachable via WWAN/Cellular
    static func isReachableViaWWAN(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.sharedInstance.reachability).connection == .cellular {            completed(NetworkManager.sharedInstance)
        }
    }
    
    // Network is reachable via WiFi
    static func isReachableViaWiFi(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.sharedInstance.reachability).connection == .wifi {            completed(NetworkManager.sharedInstance)
        }
    }
    
    
    func isConnectionAvailable() -> Bool {
        return self.connectionAvailable
    }
 
    deinit {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
}


   

