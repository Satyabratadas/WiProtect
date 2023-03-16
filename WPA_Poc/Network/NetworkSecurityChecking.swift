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
    
    
    func checkWifiSecurityType (connectionTypeText:UILabel,statusText:UILabel,completion:@escaping(Bool) -> ()) {
        
        NEHotspotNetwork.fetchCurrent { network in
            let securityType = NEHotspotNetworkSecurityType(rawValue: network?.securityType.rawValue ?? 0)

            switch securityType?.rawValue{
            case 0:
                statusText.text = "No connection"
                connectionTypeText.text = "Open Connection Not Secure"
                completion(true)
            case 1:
                connectionTypeText.text = "WEP secure"
            case 2:
                connectionTypeText.text = "WPA secure"
            case 3:
                connectionTypeText.text = "WPA enterprise secure"
            case 4:
                connectionTypeText.text = "Unknown connection not secure"
            default:
                connectionTypeText.text = "Something error"
                statusText.text = "No connection"
                completion(true)
            }
    
        }
    }
}

