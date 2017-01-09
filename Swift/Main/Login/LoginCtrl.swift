//
//  LoginCtrl.swift
//  Kanito
//
//  Created by Luciano Calderano on 16/12/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginCtrl: MYViewController {
    @IBOutlet var viewUser: UIView!
    @IBOutlet var viewPass: UIView!
    @IBOutlet var txtUser: UITextField!
    @IBOutlet var txtPass: UITextField!
    @IBOutlet var btnFb: UIButton!
    @IBOutlet var imvLogo: UIImageView!
    @IBOutlet var scrollLogin: MYInputScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let s = self.attrText (img: (UIImage.init(named: "Facebook")?.resize(newWidth: 16))!, txt: Lng("usrLogin.FB"))
        btnFb.setAttributedTitle(s, for: .normal)
        viewUser.layer.cornerRadius = 10
        viewUser.layer.borderColor = UIColor.lightGray.cgColor
        viewUser.layer.borderWidth = 2
        viewPass.layer.cornerRadius = 10
        viewPass.layer.borderColor = UIColor.lightGray.cgColor
        viewPass.layer.borderWidth = 2
        if TARGET_OS_SIMULATOR != 0 {
            txtUser.text = "provaCentro"; txtPass.text = "qwerty";
            //    txtUser.text = @"lucianotest"; txtPass.text = @"cldlcn";
            //    txtUser.text = @"luciano@kanito.it"; txtPass.text = @"Cldlcn63";
            //           txtUser.text = @"CinofiliaEU"; txtPass.text = @"papiermais55";
            txtUser.text = "MassimoPerla"; txtPass.text = "francesco"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func attrText (img: UIImage, txt: String) -> NSAttributedString {
        let imageAttach = NSTextAttachment()
        imageAttach.image =  img
        
        let str = NSMutableAttributedString(attributedString: NSAttributedString(attachment: imageAttach))
        let txt = NSMutableAttributedString(attributedString: NSAttributedString(string:" " + txt))
        
        str.append(txt)
        return str
    }

    @IBAction func btnBack () {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func btnLogin () {
        txtUser.text = txtUser.text?.trimmingCharacters(in: .whitespaces)
        txtPass.text = txtPass.text?.trimmingCharacters(in: .whitespaces)
        viewUser.layer.borderColor = UIColor.lightGray.cgColor
        viewPass.layer.borderColor = UIColor.lightGray.cgColor
        if (txtUser.text?.isEmpty)! {
            txtUser.becomeFirstResponder()
            return
        }
        if (txtPass.text?.isEmpty)! {
            txtPass.becomeFirstResponder()
            return
        }
        self.view.endEditing(true)
        
        let dic = [
            "username" : txtUser.text!,
            "password" : txtPass.text!
        ]
        self.login (dic)
    }

    // MARK: - Login Facebook
    
    @IBAction func btnFbLogin () {
        let fb = ClsFB()
        fb.viewCtrl = self
        fb.queryFacebook { (result, resultDict) in
            if result == true && resultDict?.isEmpty == false {
                self.login(resultDict as! JsonDict)
            }
            else {
                self.showAlert("Facebook error", message: (resultDict?.string("err"))!, okBlock: nil)
            }
        }
    }

    private func login (_ dict: JsonDict) {
        let request =  MYHttpRequest.pvt("login")
        request.json = dict
            
        request.start() { (success, response) in
            if success {
                self.httpResponse(response)
            }
        }
    }
    private func httpResponse(_ resultDict: JsonDict) {
        let status = resultDict.int("user.status")
        if (status == 1) {
            FollowClass.loadFollowed()
            UserClass().saveUser (resultDict.dictionary("user"),
                                  name: self.txtUser.text!,
                                  pass: self.txtUser.text!)
            
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
        else {
            self.showAlert(Lng("usrLogin.AlertTitle"), message: resultDict.string("error_msg"), okBlock: nil)
        }
    }
}

