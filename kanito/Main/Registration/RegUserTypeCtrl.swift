//
//  RegTermCondCtrl.swift
//  Kanito
//
//  Created by Luciano Calderano on 22/12/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import Foundation

class RegUserTypeCtrl: MYViewController {
    @IBOutlet private var viewSignUp: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var rect = viewSignUp.frame
        rect.origin.x = 5
        rect.origin.y = 5
        rect.size.width /= 2
        rect.size.width -= 10
        rect.size.height -= 10

        self.addSubView(rect: rect)
        rect.origin.x = viewSignUp.frame.size.width / 2 + 5
        self.addSubView(rect: rect)
        
        viewSignUp.backgroundColor = UIColor.clear
    }
    
    private func addSubView (rect: CGRect) {
        let subView = UIView()
        subView.frame = rect
        subView.backgroundColor = UIColor.white
        subView.layer.cornerRadius = 5
        subView.layer.borderColor = UIColor.myGreyDark.cgColor
        subView.layer.borderWidth = 2
        subView.layer.cornerRadius = rect.size.width / 2
        subView.alpha = 0.5
        viewSignUp.addSubview (subView)
        viewSignUp.sendSubview(toBack: subView)        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    @IBAction func btnBack () {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
}
