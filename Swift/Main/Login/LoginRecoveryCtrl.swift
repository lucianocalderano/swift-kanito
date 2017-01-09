//
//  LoginCtrl.swift
//  Kanito
//
//  Created by Luciano Calderano on 16/12/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

class LoginRecoveryCtrl: MYViewController {
    @IBOutlet var viewMail: UIView!
    @IBOutlet var txtMail: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewMail.layer.cornerRadius = 10
        viewMail.layer.borderColor = UIColor.lightGray.cgColor
        viewMail.layer.borderWidth = 2
    }
    
    private func attrText (img: UIImage, txt: String) -> NSAttributedString {
        let imageAttach = NSTextAttachment()
        imageAttach.image =  img
        
        let str = NSMutableAttributedString(attributedString: NSAttributedString(attachment: imageAttach))
        let txt = NSMutableAttributedString(attributedString: NSAttributedString(string:" " + txt))
        
        str.append(txt)
        return str
    }

    private func validateMail (mail: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate.init(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: emailRegex)
    }
    
    @IBAction func btnSend () {
        viewMail.layer.borderColor = UIColor.lightGray.cgColor
        txtMail.text = txtMail.text?.trimmingCharacters(in: .whitespaces)
        if (txtMail.text?.isEmpty)! || self.validateMail(mail: self.txtMail.text!) == false {
            viewMail.layer.borderColor = UIColor.red.cgColor
            txtMail.becomeFirstResponder()
            return
        }
        self.view.endEditing(true)
        
        let request =  MYHttpRequest.pvt("retrive-password")
        request.json = [
            "email" :  self.txtMail.text ?? ""
        ]
        
        request.start() { (success, response) in
            self.showAlert(Lng("recovery.Title"), message: "", okBlock: nil)
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
    }
}

