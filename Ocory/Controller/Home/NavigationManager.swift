//
//  NavigationManager.swift
//  Ocory
//
//  Created by malika on 17/05/23.
//

import Foundation
import UIKit

class NavigationManager {
  
    static func pushToLoginVC(from viewController: UIViewController) {
        var conn = webservices()
        
        conn.startConnectionWithPostType(getUrlString: "checkdevicetoken", params: ["":""], authRequired: true) { (value) in
            Indicator.shared.hideProgressView()
            if conn.responseCode == 1{
                print(value)
               // let device_type = (value["device_type"] as? String ?? "")
                let device_token = (value["device_token"] as? String ?? "")
                let deviceID =  UIDevice.current.identifierForVendor?.uuidString
                if device_token != deviceID{
                    
                    UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
                    if let appDomain = Bundle.main.bundleIdentifier {
                        UserDefaults.standard.removePersistentDomain(forName: appDomain)
                    }
                    UserDefaults.standard.synchronize()
                    let domain = Bundle.main.bundleIdentifier!
                    UserDefaults.standard.removePersistentDomain(forName: domain)
                    UserDefaults.standard.synchronize()
                    
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    viewController.navigationController?.pushViewController(loginVC, animated: true)
                    
                    
               //     NavigationManager.pushToLoginVC(from: self)
                }
            }
        }
    }
    
}
