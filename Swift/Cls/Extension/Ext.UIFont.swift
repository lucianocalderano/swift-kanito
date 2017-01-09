//
//  UIFontExtension.swift
//  Kanito
//
//  Created by Luciano Calderano on 28/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit
enum FontType: String {
    case Bold
    case Light
    case Regular
}


extension UIFont {
    class func mySize(_ size: CGFloat) -> UIFont {
        return self.mySize(size, type: FontType.Bold)
    }

    class func mySize(_ size: CGFloat, type: FontType) -> UIFont {
        let s = "DINAlternate-" + type.rawValue
        return UIFont(name: s, size: size)!
    }
}
