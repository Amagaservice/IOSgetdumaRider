//
//  PlaceHolderTextColor.swift
//  BeatFace
//
//  Created by malika saini on 22/08/22.
//  Copyright © 2018 Gurpreet Gulati. All rights reserved.
//

import Foundation
import UIKit

extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}
