//
//  RegistrationSubView
//  Kanito
//
//  Created by Luciano Calderano on 28/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

protocol MenuButtonViewDelegate : class {
    func menuButtonTapped (tag: Int)
}

class MenuButtonView : UIView {
    private class func Instance() -> MenuButtonView {
        let me = Bundle.main.loadNibNamed("MenuButtonView", owner: self, options: nil)?.first as! MenuButtonView
        return me
    }
    
    class func InstanceInto(_ container: MenuButtonView) -> MenuButtonView {
        let me =  MenuButtonView.Instance()
        container.addSubview(me)
        me.image.image = container.menuImage
        me.label.title = container.menuTitle!
        me.label.textColor = UIColor.white

        return me
    }
    
    @IBInspectable var menuImage:UIImage?
    @IBInspectable var menuTitle:String?

    
    @IBOutlet var label: MYLabel!
    @IBOutlet var image: UIImageView!

    weak var delegate: MenuButtonViewDelegate?
    
    override func awakeFromNib () {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
    }
    
    @IBAction func tapped (_ sender: MYButton) {
        self.delegate?.menuButtonTapped(tag: self.tag)
    }
    
//    - (void) setMenuImage:(UIImage *)menuImage {
//    _menuImage = menuImage;
//    _image.image = menuImage;
//    }
//    
//    - (void) setMenuTitle:(NSString *)menuTitle {
//    _menuTitle = menuTitle;
//    _label.title = menuTitle;
//    }

}
