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
    
    func checkWifiSecurityType(completion: @escaping(NetworkStatus) -> ()) {
        let monitor = NWPathMonitor()
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
            }else{
                
            }
        }
    }
}

