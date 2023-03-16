//
//  NetworkSecurityChecking.swift
//  WPA_Poc
//
//  Created by Satyabrata Das on 15/03/23.
//

import Foundation
import UIKit
import NetworkExtension

enum NetworkStatus{
    case Unsecured, Secured
}

class NetworkSecurityCheck{
    // Check wifi protocol security type like Unsecure,WEP,WPA,WPA2
    func checkWifiSecurityType(completion: @escaping(NetworkStatus) -> ()) {
        let monitor = NWPathMonitor()                                                               // Observe wifi connection in every time that which wifi connected
        monitor.start(queue: DispatchQueue.global(qos: .background))
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                
                NEHotspotNetwork.fetchCurrent { network in
                    let securityType = NEHotspotNetworkSecurityType(rawValue: network?.securityType.rawValue ?? 0)
                    
                    switch securityType?.rawValue{
                    case 0:
                        completion(.Unsecured)
                    case 1:
                        completion(.Secured)
                    case 2:
                        completion(.Secured)
                    case 3:
                        completion(.Secured)
                    case 4:
                        completion(.Unsecured)
                    default:
                        completion(.Unsecured)
                    }
                }
            }
        }
    }
}

