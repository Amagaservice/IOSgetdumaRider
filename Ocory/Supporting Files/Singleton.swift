//
//  Singleton.swift
//  Ocory
//
//  Created by nile on 30/08/21.
//

import Foundation
import UIKit

class Singleton {
    
    static var shared: Singleton? = Singleton()
    
    private init() {
        
    }
    
    deinit {
        print(#file , " Destructed")
    }
    let title = "GetDuma"
    var driverData : userCustomerModal?
    
}

