//
//  NetworkSecurityChecking.swift
//  WPA_Poc
//
//  Created by Satyabrata Das on 15/03/23.
//

import Foundation
import UIKit
import NetworkExtension

class NetworkSecurityCheck{
    
    
    func checkWifiSecurityType (completion:@escaping(String) -> ()) {
        let monitor = NWPathMonitor()
        monitor.start(queue: DispatchQueue.global(qos: .background))
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                
                NEHotspotNetwork.fetchCurrent { network in
                    let securityType = NEHotspotNetworkSecurityType(rawValue: network?.securityType.rawValue ?? 0)
                    
                    switch securityType?.rawValue{
                    case 0:
                        completion("unsecure")
                    case 1:
                        completion("secure")
                    case 2:
                        completion("secure")
                    case 3:
                        completion("secure")
                    case 4:
                        completion("unsecure")
                    default:
                        completion("unsecure")
                    }
                    
                }
            }else{
                
            }
        }
    }
}

