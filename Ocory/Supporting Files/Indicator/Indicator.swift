//
//  Indicator.swift
//  Ocory
//
//  Created by Arun Singh on 26/02/21.
//

import Foundation
import UIKit

open class Indicator {
    
    var containerView = UIView()
    
    var progressView = UIView()
    
    var activityIndicator = UIActivityIndicatorView()
    
    open class var shared: Indicator {
        
        struct Static {
            
            static let instance: Indicator = Indicator()
            
        }
        
        return Static.instance
        
    }
    
    open func showProgressView(_ view: UIView) {
        
        containerView.frame = view.frame
        print(containerView.frame,"1")
        containerView.center = view.center
        containerView.backgroundColor = UIColor(hex: 0x1F232E, alpha: 0.3)
        
        progressView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        progressView.center = view.center
        progressView.backgroundColor = UIColor(hex: 0xFFFFFF, alpha: 1)
        progressView.clipsToBounds = true
        progressView.layer.cornerRadius = 10
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        activityIndicator.style = .gray
        activityIndicator.center = CGPoint(x: progressView.bounds.width / 2, y: progressView.bounds.height / 2)
        
        progressView.addSubview(activityIndicator)
        containerView.addSubview(progressView)
        view.addSubview(containerView)
        
        activityIndicator.startAnimating()
    }
    
    open func hideProgressView() {
        
        activityIndicator.stopAnimating()
        containerView.removeFromSuperview()
        
    }
}

extension UIColor {
    
    convenience init(hex: UInt32, alpha: CGFloat) {
        let red = CGFloat((hex & 0xFF0000) >> 16)/256.0
        let green = CGFloat((hex & 0xFF00) >> 8)/256.0
        let blue = CGFloat(hex & 0xFF)/256.0
        
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
        
    }
}
