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
    case Unsecured, WPA_secured, WEP_secured, Enterprise_secured
}

class NetworkSecurityCheck{
    // Check wifi protocol security type like Unsecure,WEP,WPA,WPA2
    func checkWifiSecurityType(completion: @escaping(NetworkStatus) -> ()) {
        let monitor = NWPathMonitor()                                                               // Observe wifi connection in every time that which wifi connected
        monitor.start(queue: DispatchQueue.global(qos: .background))
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                
                NEHotspotNetwork.fetchCurrent { network in
                    print(network?.ssid as Any)
                    print(network?.bssid as Any)
                   
                    let securityType = NEHotspotNetworkSecurityType(rawValue: network?.securityType.rawValue ?? 0)
                    
                    switch securityType?.rawValue{
                    case 0:
                        completion(.Unsecured)
                    case 1:
                        completion(.WEP_secured)
                    case 2:
                        completion(.WPA_secured)
                    case 3:
                        completion(.Enterprise_secured)
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

