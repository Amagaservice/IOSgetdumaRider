//
//  SetView.swift
//  Ocory
//
//  Created by Arun Singh on 22/02/21.
//

import Foundation
import UIKit
//@IBDesignable
class SetView: UIView {
    
    @IBInspectable
    open var BorderColor:UIColor = UIColor.lightGray {
        didSet {
            self.UpdateBorder()
        }
    }
    
    @IBInspectable
    open var BorderWidth:CGFloat = 0 {
        didSet {
            self.UpdateBorder()
        }
    }
    
    @IBInspectable
    open var isCircle:Bool = false {
        didSet {
            self.UpdateBorder()
        }
    }
    
    @IBInspectable
    open var CornerRadius:CGFloat = 0 {
        didSet {
            self.UpdateBorder()
        }
    }
    
    @IBInspectable
    open var EnableShadow:Bool = false {
        didSet {
            self.SetShadow()
        }
    }
    
    @IBInspectable
    open var ShadowColor:UIColor = UIColor.lightGray {
        didSet {
            self.SetShadow()
        }
    }
    
    @IBInspectable
    open var ShadowRadius:CGFloat = 0 {
        didSet {
            self.SetShadow()
        }
    }
    
    @IBInspectable
    open var ShadowOpacity:Float = 0 {
        didSet {
            self.SetShadow()
        }
    }
    
    @IBInspectable
    open var ShadowOffsetX:CGFloat = 0 {
        didSet {
            self.SetShadow()
        }
    }
    
    @IBInspectable
    open var ShadowOffsetY:CGFloat = 0 {
        didSet {
            self.SetShadow()
        }
    }
    
    func UpdateBorder(){
        
        self.layer.borderWidth = BorderWidth
        self.layer.borderColor = BorderColor.cgColor
        if isCircle {
            self.layer.cornerRadius = self.frame.size.width/2
        }else {
            self.layer.cornerRadius = CornerRadius
        }
        self.layer.masksToBounds = true
        
    }
    
    func SetShadow(){
        
        if EnableShadow {
            self.layer.masksToBounds = false
            self.layer.shadowColor = ShadowColor.cgColor
            self.layer.shadowOpacity = ShadowOpacity
            self.layer.shadowOffset = CGSize(width: ShadowOffsetX, height: ShadowOffsetY)
            self.layer.shadowRadius = ShadowRadius
        }
        
    }
    
}

//@IBDesignable
class SetButton: UIButton {
    
//    @IBInspectable
//    open var borderColor:UIColor = gray {
//        didSet {
//            self.UpdateBorder()
//        }
//    }
    
    @IBInspectable
    open var BordWidth:CGFloat = 0 {
        didSet {
            self.UpdateBorder()
        }
    }
    
    @IBInspectable
    open var isCircle:Bool = false {
        didSet {
            self.UpdateBorder()
        }
    }
    
    @IBInspectable
    open var CornRadius:CGFloat = 0 {
        didSet {
            self.UpdateBorder()
        }
    }
    
    @IBInspectable
    open var EnableShadow:Bool = false {
        didSet {
            self.SetShadow()
        }
    }
    
    @IBInspectable
    open var ShadowColor:UIColor = UIColor.lightGray {
        didSet {
            self.SetShadow()
        }
    }
    
    @IBInspectable
    open var ShadowRadius:CGFloat = 0 {
        didSet {
            self.SetShadow()
        }
    }
    
    @IBInspectable
    open var ShadowOpacity:Float = 0 {
        didSet {
            self.SetShadow()
        }
    }
    
    @IBInspectable
    open var ShadowOffsetX:CGFloat = 0 {
        didSet {
            self.SetShadow()
        }
    }
    
    @IBInspectable
    open var ShadowOffsetY:CGFloat = 0 {
        didSet {
            self.SetShadow()
        }
    }

    
    @IBInspectable
    open var LeftPaddingSize:CGFloat = 0 {
        didSet {
            self.SetPadding()
        }
    }
    
    @IBInspectable
    open var RightPaddingSize:CGFloat = 0 {
        didSet {
            self.SetPadding()
        }
    }
    
    @IBInspectable
    open var TopPaddingSize:CGFloat = 0 {
        didSet {
            self.SetPadding()
        }
    }
    
    @IBInspectable
    open var BottomPaddingSize:CGFloat = 0 {
        didSet {
            self.SetPadding()
        }
    }
    
    func SetPadding(){
        
        self.titleEdgeInsets = UIEdgeInsets(top: TopPaddingSize, left: LeftPaddingSize, bottom: BottomPaddingSize, right: RightPaddingSize)
    }
    
    func UpdateBorder(){
        
        self.layer.borderWidth = BordWidth
      //  self.layer.borderColor = borderColor.cgColor
        if isCircle {
            self.layer.cornerRadius = self.frame.size.width/2
        }else {
            self.layer.cornerRadius = CornRadius
        }
        self.layer.masksToBounds = true
        
    }
    
    func SetShadow(){
        
        if EnableShadow {
            self.layer.masksToBounds = false
            self.layer.shadowColor = ShadowColor.cgColor
            self.layer.shadowOpacity = ShadowOpacity
            self.layer.shadowOffset = CGSize(width: ShadowOffsetX, height: ShadowOffsetY)
            self.layer.shadowRadius = ShadowRadius
        }
    }
}

class SetTextField: UITextField {
    
    @IBInspectable
    open var BorderColor:UIColor = UIColor.lightGray {
        didSet {
            self.UpdateBorder()
        }
    }
    
    @IBInspectable
    open var BorderWidth:CGFloat = 0 {
        didSet {
            self.UpdateBorder()
        }
    }
    
    @IBInspectable
    open var isCircle:Bool = false {
        didSet {
            self.UpdateBorder()
        }
    }
    
    @IBInspectable
    open var CornerRadius:CGFloat = 10 {
        didSet {
            self.UpdateBorder()
        }
    }
    
    @IBInspectable
    open var EnableShadow:Bool = false {
        didSet {
            self.SetShadow()
        }
    }
    
    @IBInspectable
    open var ShadowColor:UIColor = UIColor.lightGray {
        didSet {
            self.SetShadow()
        }
    }
    
    @IBInspectable
    open var ShadowRadius:CGFloat = 0 {
        didSet {
            self.SetShadow()
        }
    }
    
    @IBInspectable
    open var ShadowOpacity:Float = 0 {
        didSet {
            self.SetShadow()
        }
    }
    
    @IBInspectable
    open var ShadowOffsetX:CGFloat = 0 {
        didSet {
            self.SetShadow()
        }
    }
    
    @IBInspectable
    open var ShadowOffsetY:CGFloat = 0 {
        didSet {
            self.SetShadow()
        }
    }

    
    @IBInspectable
    open var LeftPaddingSize:CGFloat = 0 {
        didSet {
            self.SetPadding()
        }
    }
    
    @IBInspectable
    open var RightPaddingSize:CGFloat = 0 {
        didSet {
            self.SetPadding()
        }
    }
    
    @IBInspectable
    open var TopPaddingSize:CGFloat = 0 {
        didSet {
            self.SetPadding()
        }
    }
    
    @IBInspectable
    open var BottomPaddingSize:CGFloat = 0 {
        didSet {
            self.SetPadding()
        }
    }
    
    func SetPadding(){
       
      //  self.titleEdgeInsets = UIEdgeInsets(top: TopPaddingSize, left: LeftPaddingSize, bottom: BottomPaddingSize, right: RightPaddingSize)
    }
    
    func UpdateBorder(){
        
        self.layer.borderWidth = BorderWidth
        self.layer.borderColor = BorderColor.cgColor
        if isCircle {
            self.layer.cornerRadius = self.frame.size.width/2
        }else {
            self.layer.cornerRadius = CornerRadius
        }
        self.layer.masksToBounds = true
        
    }
    
    func SetShadow(){
        
        if EnableShadow {
            self.layer.masksToBounds = false
            self.layer.shadowColor = ShadowColor.cgColor
            self.layer.shadowOpacity = ShadowOpacity
            self.layer.shadowOffset = CGSize(width: ShadowOffsetX, height: ShadowOffsetY)
            self.layer.shadowRadius = ShadowRadius
        }
    }
}


@IBDesignable
class SetImageView: UIImageView {
    
//    @IBInspectable
//    open var borderColor:UIColor?
//    borderColor = UIColor.gray {
//        didSet {
//            self.UpdateBorder()
//        }
//    }
    
    @IBInspectable
    open var BordWidth:CGFloat = 0 {
        didSet {
            self.UpdateBorder()
        }
    }
    
    @IBInspectable
    open var isCircle:Bool = false {
        didSet {
            self.UpdateBorder()
        }
    }
    
    @IBInspectable
    open var CornRadius:CGFloat = 0 {
        didSet {
            self.UpdateBorder()
        }
    }
    
    @IBInspectable
    open var EnableShadow:Bool = false {
        didSet {
            self.SetShadow()
        }
    }
    
    @IBInspectable
    open var ShadowColor:UIColor = UIColor.lightGray {
        didSet {
            self.SetShadow()
        }
    }
    
    @IBInspectable
    open var ShadowRadius:CGFloat = 0 {
        didSet {
            self.SetShadow()
        }
    }
    
    @IBInspectable
    open var ShadowOpacity:Float = 0 {
        didSet {
            self.SetShadow()
        }
    }
    
    @IBInspectable
    open var ShadowOffsetX:CGFloat = 0 {
        didSet {
            self.SetShadow()
        }
    }
    
    @IBInspectable
    open var ShadowOffsetY:CGFloat = 0 {
        didSet {
            self.SetShadow()
        }
    }
    
    func UpdateBorder(){
        
        self.layer.borderWidth = BordWidth
      //  self.layer.borderColor = borderColor?.cgColor
        if isCircle {
            self.layer.cornerRadius = self.frame.size.width/2
        }else {
            self.layer.cornerRadius = CornRadius
        }
        self.layer.masksToBounds = true
        
    }
    
    func SetShadow(){
        if EnableShadow {
            self.layer.masksToBounds = false
            self.layer.shadowColor = ShadowColor.cgColor
            self.layer.shadowOpacity = ShadowOpacity
            self.layer.shadowOffset = CGSize(width: ShadowOffsetX, height: ShadowOffsetY)
            self.layer.shadowRadius = ShadowRadius
        }
        
    }
    
}
