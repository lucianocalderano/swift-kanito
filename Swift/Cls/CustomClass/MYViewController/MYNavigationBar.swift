//
//  MyNavigationBar.swift
//  Kanito
//
//  Created by Luciano Calderano on 17/11/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

@objc public protocol MYNavigationBarDelegate: class {
    func myNavigatorBackButtonTapped()
    func myNavigatorOptionButtonTapped()
}

@objc class MYNavigationBar : UINavigationBar {

    @IBOutlet var titleLabel: MYLabel!
    @IBOutlet var sxButton: UIButton!
    @IBOutlet var dxButton: UIButton!
    
    var defaultImageBack: UIImage?
    
    weak var barDelegate:MYNavigationBarDelegate?

    var backButtonImage: UIImage! {
        set {
            if (newValue == nil) {
                self.sxButton.setImage(self.defaultImageBack, for: .normal)
            }
            else {
                self.sxButton.setImage(newValue, for: .normal)
            }
        }
        get {
            return self.sxButton.imageView?.image
        }
    }

    var optionButtonImage: UIImage! {
        set {
            self.dxButton.setImage(newValue, for: .normal)
            self.dxButton.isHidden = (newValue == nil)
        }
        get {
            return self.dxButton.imageView?.image
        }
    }
    
    var titolo: String {
        set {
            if newValue.isEmpty {
                titleLabel.text = ""
            }
            else {
                titleLabel.text = newValue.tryLang()
            }
        }
        get {
            return titleLabel.text!
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    private func initialize() {
        let nib = UINib(nibName: "MYNavigationBar", bundle: nil)
        
        let barXibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        barXibView.frame = self.bounds
        barXibView.backgroundColor = UIColor.clear
        barXibView.tintColor = UIColor.white
        
        addSubview(barXibView)
        self.defaultImageBack = self.sxButton.backgroundImage(for: .normal)
        UINavigationBar.appearance().tintColor = UIColor.black
    }
    
    @IBAction func sxButtonTapped() {
        self.barDelegate?.myNavigatorBackButtonTapped()
    }
    
    @IBAction func dxButtonTapped () {
        self.barDelegate?.myNavigatorOptionButtonTapped()
    }
}
