//
//  MainMenuSubView
//  Kanito
//
//  Created by Luciano Calderano on 28/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

protocol MainMenuSubViewDelegate : class {
    func menuButtonTapped (item: Int)
}

class MainMenuSubView : UIView, MenuButtonViewDelegate {

    var userType: UserType {
        set {
            switch newValue {
            case .pvt:
                self.logoutBtn.isHidden = false
                self.bizBtn.isHidden = true
            case .biz:
                self.logoutBtn.isHidden = false
                self.bizBtn.isHidden = false
            default:
                self.logoutBtn.isHidden = true
                self.bizBtn.isHidden = true
            }
        }
        get {
            return UserType.None
        }
    }
    
    @IBOutlet var myKanitoBtn: MenuButtonView!
    @IBOutlet private var homeBtn: MenuButtonView!
    @IBOutlet private var bizBtn: MenuButtonView!
    @IBOutlet private var logoutBtn: MenuButtonView!
    
    @IBOutlet private var leftConstant: NSLayoutConstraint!
    
    private var screenShot: UIImageView!
    private var savedMainView: UIView!
    
    var mainView: UIView {
        set {
            self.screenShotMainView(main: newValue)
        }
        get {
            return self.savedMainView!
        }
    }
    weak var delegate: MainMenuSubViewDelegate?
    
    override func awakeFromNib () {
        super.awakeFromNib()
        self.backgroundColor = UIColor.white
        
        self.initialize(btn: self.myKanitoBtn, tag: .MyKanito)
        self.initialize(btn: self.homeBtn, tag: .Home)
        self.initialize(btn: self.bizBtn, tag: .DogBuddy)
        self.initialize(btn: self.logoutBtn, tag: .Logout)
        
        self.leftConstant.constant = -self.frame.size.width
    }

    func screenShotMainView (main: UIView) {
        if (self.savedMainView != nil) && self.savedMainView == main {
            return
        }
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        self.savedMainView = main

        self.screenShot = UIImageView.init(frame: (self.savedMainView.bounds))
        self.screenShot.image = image
        self.savedMainView.addSubview(self.screenShot!)
        self.screenShot.isHidden = true
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector (moveMenu))
        self.screenShot.addGestureRecognizer(tap)
        self.screenShot.isUserInteractionEnabled = true
    }
    
    private func initialize (btn: MenuButtonView, tag:ItemMenu) {
        let btn = MenuButtonView.InstanceInto(btn)
        btn.label.textColor = UIColor.myOrange
        btn.delegate = self
        btn.tag = tag.hashValue
    }

    func closeMenu()  {
        if self.leftConstant.constant == 0 {
            self.moveMenu()
        }
    }
    
    func moveMenu () {
        UIView.animate(withDuration: 0.25, animations: {
            self.leftConstant.constant = self.leftConstant.constant == 0 ? -self.frame.size.width : 0
            self.mainView.layoutIfNeeded()
            
            self.screenShot.isHidden = false
            
            var rect = (self.screenShot?.frame)!
            rect.origin.x = self.leftConstant.constant + self.frame.width
            self.screenShot.frame = rect
        }, completion: { finished in
            if self.leftConstant.constant < 0 {
                self.screenShot.isHidden = true
            }
        })
    }
    
    func menuButtonTapped (tag: Int) {
        self.delegate?.menuButtonTapped (item: tag)
    }
}
