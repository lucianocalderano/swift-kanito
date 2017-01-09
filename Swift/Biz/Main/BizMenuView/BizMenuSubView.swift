//
//  RegistrationSubView
//  Kanito
//
//  Created by Luciano Calderano on 28/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit


protocol BizMenuSubViewDelegate : class {
    func menuButtonTapped (item: Int)
}

class BizMenuSubView : UIView, MenuButtonViewDelegate {
    class func InstanceInto(_ container: BizMenuSubView) -> BizMenuSubView {
        let me =  BizMenuSubView.Instance()
        container.addSubview(me)
        
        return me
    }
    
    private class func Instance() -> BizMenuSubView {
        return Bundle.main.loadNibNamed("BizMenuSubView", owner: self, options: nil)?.first as! BizMenuSubView
    }

    
    @IBOutlet private var dashBtn: MenuButtonView!
    @IBOutlet private var custBtn: MenuButtonView!
    @IBOutlet private var dogsBtn: MenuButtonView!
    @IBOutlet private var lessBtn: MenuButtonView!
    @IBOutlet private var pvt_Btn: MenuButtonView!
    @IBOutlet private var out_Btn: MenuButtonView!
    
    var mainView: UIView?
    var screenShot: UIImageView?
    weak var delegate: BizMenuSubViewDelegate?
    
    override func awakeFromNib () {
        super.awakeFromNib()
        self.backgroundColor = UIColor.myBlueLight
        
        self.initialize(btn: self.dashBtn, tag: .Dash)
        self.initialize(btn: self.custBtn, tag: .Cust)
        self.initialize(btn: self.dogsBtn, tag: .Dog)
        self.initialize(btn: self.lessBtn, tag: .Less)
        self.initialize(btn: self.pvt_Btn, tag: .Home)
        self.initialize(btn: self.out_Btn, tag: .Logout)
        
        var rect = self.frame
        rect.size.height = UIScreen.main.bounds.size.height
        rect.origin.x = -rect.size.width
        self.frame = rect
        self.isHidden = true
    }
    
    func addMenuInView (mainView: UIView) {
        mainView.addSubview(self)
        self.mainView = mainView
        
        UIGraphicsBeginImageContext((self.mainView?.frame.size)!)
        self.mainView?.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.screenShot = UIImageView.init(frame: (self.mainView?.bounds)!)
        self.screenShot?.image = image
        self.mainView?.addSubview(self.screenShot!)
        self.screenShot?.isHidden = true

        let tap = UITapGestureRecognizer.init(target: self, action: #selector (moveMenu))
        self.screenShot?.addGestureRecognizer(tap)
        self.screenShot?.isUserInteractionEnabled = true
    }
    
    private func initialize (btn: MenuButtonView, tag:ItemMenu) {
        let btn = MenuButtonView.InstanceInto(btn)
        btn.label.textColor = UIColor.white
        btn.delegate = self
        btn.tag = tag.hashValue
    }

    func closeMenu()  {
        if self.frame.origin.x == 0 {
            self.moveMenu()
        }
    }
    
    func moveMenu () {
        UIView.animate(withDuration: 0.3, animations: {
            var rect = self.frame
            rect.origin.x = rect.origin.x == 0 ? -rect.size.width : 0
            self.frame = rect
            self.isHidden = false
            
            rect = (self.screenShot?.frame)!
            rect.origin.x = self.frame.origin.x + self.frame.size.width
            self.screenShot?.isHidden = false
            self.screenShot?.frame = rect
        }, completion: { finished in
            if self.screenShot?.frame.origin.x == 0 as CGFloat {
                self.screenShot?.isHidden = true
            }
        })
    }
    
    func menuButtonTapped (tag: Int) {
        self.delegate?.menuButtonTapped (item: tag)
    }
    //                - (void) showMenu {
    //                    [self.clsMenu showMenu];
    //                    }
    //
    //                    - (void) hideMenu {
    //                        [self.clsMenu hideMenu];
    //}

}
