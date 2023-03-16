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
                self.networkStatus.text = "Connection Available"
                self.networkSecurity.checkWifiSecurityType(connectionTypeText: self.networkConnectionType, statusText: self.networkStatus, completion: { result in
                    print(result)
                    if result != false{
                        self.showAlert(title: "Connection not secure", message: "") {

                        }
                    }
                })
                
            
            }else{
                self.networkStatus.text = "Connection Not available"
                self.networkConnectionType.text = "No connection"
            }

        }

    }
   
    func showAlert(title : String , message : String , completion : @escaping () -> ()) {
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
  
}

