//
//  MyViewController.swift
//  Enci
//
//  Created by Luciano Calderano on 26/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

class MYViewController: UIViewController, MYNavigationBarDelegate {
    var myNavigationBar:MYNavigationBar?
    
    @IBInspectable var headerTitle:String?
    @IBInspectable var backImage:UIImage?
    @IBInspectable var optionImage:UIImage?

    var dataArray: Array = [Any]()

    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.myNavigationBar = self.navigationController?.navigationBar as! MYNavigationBar?
        self.myNavigationBar?.setBackgroundImage(UIImage.init(), for: UIBarMetrics.default)
        self.myNavigationBar?.shadowImage = nil
        
        self.view.backgroundColor = UIColor.white
        self.tabBarController?.navigationItem.hidesBackButton = true
        
        self.navigationItem.setHidesBackButton(true, animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.myNavigationBar?.isHidden = false
        self.myNavigationBar?.barDelegate = self
        if self.headerTitle == nil {
            self.headerTitle = ""
        }
        self.myNavigationBar?.titolo = self.headerTitle!
        self.myNavigationBar?.backButtonImage = self.backImage
        self.myNavigationBar?.optionButtonImage = self.optionImage
    }
    
    func myNavigatorBackButtonTapped() {
        if self.navigationController?.viewControllers.count == 1 {
            _ = self.dismiss(animated: true, completion: nil)
        }
        else {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    func myNavigatorOptionButtonTapped () {
        print("MyNavigationBarOptionButtonTapped")
    }
}
