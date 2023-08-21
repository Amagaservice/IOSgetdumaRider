////
////  TxtFld.swift
////  Pheemee
////
////  Created by malika saini on 22/08/22.
////  Copyright © 2018 Gurpreet Gulati. All rights reserved.

import Foundation
import UIKit

private var kAssociationKeyMaxLength: Int = 0


//    extension UIView {
////
////        @IBInspectable var cornerRadius: CGFloat {
////
////            get {
////
////                return layer.cornerRadius
////
////            }
////
////            set {
////
////                layer.cornerRadius = newValue
////
////                layer.masksToBounds = newValue > 0
////
////
////            }
////
////        }
//
//        @IBInspectable var borderWidth: CGFloat {
//
//            get {
//
//                return layer.borderWidth
//
//            }
//
//            set {
//
//                layer.borderWidth = newValue
//
//            }
//
//        }
//
//        @IBInspectable var borderColor: UIColor? {
//
//            get {
//
//                return UIColor(cgColor: layer.borderColor!)
//
//            }
//
//            set {
//
//                layer.borderColor = newValue?.cgColor
//
//            }
//        }
//
////        @IBInspectable
////        var shadowRadius: CGFloat {
////            get {
////                return layer.shadowRadius
////            }
////            set {
////                layer.shadowRadius = newValue
////            }
////        }
//
//  //      @IBInspectable
////        var shadowOpacity: Float {
////            get {
////                return layer.shadowOpacity
////            }
////            set {
////                layer.shadowOpacity = newValue
////            }
////        }
//
//        @IBInspectable
//        var shadowOffset: CGSize {
//            get {
//                return layer.shadowOffset
//            }
//            set {
//                layer.shadowOffset = newValue
//            }
//        }
//
////        @IBInspectable
////        var shadowColor: UIColor? {
////            get {
////                if let color = layer.shadowColor {
////                    return UIColor(cgColor: color)
////                }
////                return nil
////            }
////            set {
////                if let color = newValue {
////                    layer.shadowColor = color.cgColor
////                } else {
////                    layer.shadowColor = nil
////                }
////            }
////        }
//
//
//    }
    
    extension UIButton {

        func roundedButton(){

            let maskPAth1 = UIBezierPath(roundedRect: self.bounds,

                                         byRoundingCorners: [.topLeft , .topRight],

                                         cornerRadii:CGSize(width:8.0, height:8.0))

            let maskLayer1 = CAShapeLayer()

            maskLayer1.frame = self.bounds

            maskLayer1.path = maskPAth1.cgPath

            self.layer.mask = maskLayer1

        }

    }
    
    extension UITextField {

        func setLeftPaddingPoints(_ amount:CGFloat){
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
            self.leftView = paddingView
            self.leftViewMode = .always
        }

        func setRightPaddingPoints(_ amount:CGFloat) {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
            self.rightView = paddingView
            self.rightViewMode = .always
        }
    }
    
    extension UITextField {

        @IBInspectable var maxLength: Int {
            get {
                if let length = objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int {
                    return length
                } else {
                    return Int.max
                }
            }
            set {
                objc_setAssociatedObject(self, &kAssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
                addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
            }
        }

        @objc func checkMaxLength(textField: UITextField) {
            guard let prospectiveText = self.text,
                prospectiveText.count > maxLength
                else {
                    return
            }

            let selection = selectedTextRange

            let indexEndOfText = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
            let substring = prospectiveText[..<indexEndOfText]
            text = String(substring)

            selectedTextRange = selection
        }
}



