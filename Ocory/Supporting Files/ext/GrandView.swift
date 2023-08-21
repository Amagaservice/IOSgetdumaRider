//
//  GrandView.swift
//  couchvibes-ios
//
//  Created by malika on 22/08/22.
//

import UIKit
import Foundation

@IBDesignable class GradientUIView1: UIView {
    @IBInspectable var firstColor: UIColor = UIColor.white
    @IBInspectable var secondColor: UIColor = UIColor.white
    @IBInspectable var thirdColor: UIColor = UIColor.white
    @IBInspectable var cornerRadius1: CGFloat = 0
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    private lazy var gradientLayer: CAGradientLayer = {
        let Gradient = CAGradientLayer()
        Gradient.frame = self.bounds
        Gradient.colors = [firstColor.cgColor,secondColor.cgColor,thirdColor.cgColor]
        Gradient.cornerRadius = cornerRadius1
        layer.insertSublayer(Gradient, at: 0)
        return Gradient
    }()
}
@IBDesignable class GradientUIView: UIView{
    @IBInspectable var firstColor: UIColor = UIColor.white
    @IBInspectable var secondColor: UIColor = UIColor.white
    @IBInspectable var thirdColor: UIColor = UIColor.white
    @IBInspectable var cornerRadius1: CGFloat = 0


    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    private lazy var gradientLayer: CAGradientLayer = {
        let Gradient = CAGradientLayer()
        Gradient.frame = self.bounds
        Gradient.colors = [firstColor.cgColor,secondColor.cgColor,thirdColor.cgColor]
        Gradient.cornerRadius = cornerRadius1
        if #available(iOS 11.0, *) {
            Gradient.maskedCorners = [.layerMinXMinYCorner,.layerMinXMaxYCorner]
        }
        Gradient.startPoint = CGPoint(x: 0, y: 0.5)
        Gradient.endPoint = CGPoint(x: 1, y: 0.7)
        layer.insertSublayer(Gradient, at: 0)
        return Gradient
    }()
}
@IBDesignable class GradientVatiUIView: UIView {
    @IBInspectable var firstColor: UIColor = UIColor.white
    @IBInspectable var secondColor: UIColor = UIColor.white
    @IBInspectable var thirdColor: UIColor = UIColor.white
    @IBInspectable var cornerRadius1: CGFloat = 0


    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    private lazy var gradientLayer: CAGradientLayer = {
        let Gradient = CAGradientLayer()
        Gradient.frame = self.bounds
        Gradient.colors = [firstColor.cgColor,secondColor.cgColor,thirdColor.cgColor]
        Gradient.cornerRadius = cornerRadius1
        if #available(iOS 11.0, *) {
            Gradient.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
        }
        layer.insertSublayer(Gradient, at: 0)
        return Gradient
    }()
}
@IBDesignable class GradientUIBtn: UIButton {
    @IBInspectable var firstColor: UIColor = UIColor.clear
    @IBInspectable var secondColor: UIColor = UIColor.clear
    @IBInspectable var thirdColor: UIColor = UIColor.clear
    @IBInspectable var cornerRadius1: CGFloat = 0
    var Gradient = CAGradientLayer()

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    private lazy var gradientLayer: CAGradientLayer = {
        Gradient.frame = self.bounds
        Gradient.colors = [firstColor.cgColor,secondColor.cgColor,thirdColor.cgColor]
        Gradient.cornerRadius = cornerRadius1
        Gradient.startPoint = CGPoint(x: 0, y: 0.5)
        Gradient.endPoint = CGPoint(x: 1, y: 0.5)
        layer.insertSublayer(Gradient, at: 0)
        return Gradient
    }()
    
}
extension UIButton
{
    func addBlurEffect(){
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blur.frame = self.bounds
        blur.isUserInteractionEnabled = false
        self.insertSubview(blur, at: 0)
        if let imageView = self.imageView{
            self.bringSubviewToFront(imageView)
        }
    }
}


@IBDesignable
class GradientView: UIView {
    
    @IBInspectable var firstColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var secondColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }

    @IBInspectable var isHorizontal: Bool = true {
        didSet {
            updateView()
        }
    }
    
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    func updateView() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [firstColor, secondColor].map {$0.cgColor}
        if (isHorizontal) {
            layer.startPoint = CGPoint(x: 0, y: 0.5)
            layer.endPoint = CGPoint (x: 1, y: 0.5)
        } else {
            layer.startPoint = CGPoint(x: 0.5, y: 0)
            layer.endPoint = CGPoint (x: 0.5, y: 1)
        }
    }
    
}
