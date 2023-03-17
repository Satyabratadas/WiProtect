//
//  ViewController.swift
//  WPA_Poc
//
//  Created by Satyabrata Das on 14/03/23.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var networkStatus: UILabel!
    @IBOutlet weak var networkConnectionType: UILabel!
//    var reachable : Reachability?
    let networkManager = NetworkManager.sharedInstance
    let networkSecurity = NetworkSecurityCheck()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.networkManager.completion = { (isConnectionAvailable) in
            
            if isConnectionAvailable != false{
                self.networkStatus.text = "Connection available"
                self.networkSecurity.checkWifiSecurityType { securityStatus in
                    switch securityStatus{
                    case .Unsecured:
                        self.showAlertUnsecure(title: "Connection not secure", message: "Not continue this application") {
                            self.networkConnectionType.text = "Unsecure connection harmful"
                        }
                    case .WPA_secured:
                        self.showAlertSecure(title: "WPA Secure connection", message: "Continue this application") {
                            self.networkConnectionType.text = "Secure Connection"
                        }
                    case .WEP_secured:
                        self.showAlertSecure(title: "WEP Secure connection", message: "Continue this application") {
                            self.networkConnectionType.text = "Secure Connection"
                        }
                    case .Enterprise_secured:
                        self.showAlertSecure(title: "WPA_Enterprise Secure connection", message: "Continue this application") {
                            self.networkConnectionType.text = "Secure Connection"
                        }
                    }
                }
            }else{
                self.networkStatus.text = "Connection Not available"
                self.networkConnectionType.text = "No connection"
            }
            
        }

    }
   // if connection is unsecure show alert and stop the application
    func showAlertUnsecure(title : String , message : String , completion : @escaping () -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                 DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                  exit(0)
                 }
            }
            completion()
        }))
        self.present(alert, animated: true)
        
    }
    //if connection is secure then continue the application
    func showAlertSecure(title : String , message : String , completion : @escaping () -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            completion()
        }))
        self.present(alert, animated: true)
        
    }
  
}

