//
//  MYColor
//  Enci
//
//  Created by Luciano Calderano on 28/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

extension UIColor {
    static let myBlueLight  = UIColor.init(netHex: 0x00aed9)
    static let myMenuSel    = UIColor.init(netHex: 0x646781)
    static let myMenuBkg    = UIColor.init(netHex: 0x464960)
    static let myGreyLight  = UIColor.init(netHex: 0xd6dddf)
    static let myGreyDark   = UIColor.init(netHex: 0x4c505c)
    static let myOrange     = UIColor.init(netHex: 0xff9900)
    
    convenience init(r: Int, g: Int, b: Int) {
        assert(r >= 0 && r <= 255, "Invalid red component")
        assert(g >= 0 && g <= 255, "Invalid green component")
        assert(b >= 0 && b <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1.0)
    }
    convenience init(netHex:Int) {
        self.init(r:(netHex >> 16) & 0xff, g:(netHex >> 8) & 0xff, b:netHex & 0xff)
    }
}
