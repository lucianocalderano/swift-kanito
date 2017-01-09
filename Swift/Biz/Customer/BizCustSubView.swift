//
//  RegistrationSubView
//  Kanito
//
//  Created by Luciano Calderano on 28/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

protocol BizCustSubViewDelegate : class {
    func BizCustSubViewTappedItem (item: Int)
}

class BizCustSubView : UIViewController {
    
    class func instanceFromSb (_ sb: UIStoryboard!) -> BizCustSubView {
        return sb.instantiateViewController(withIdentifier: "BizCustSubView") as! BizCustSubView
    }

    var dict:JsonDict {
        set {
            self.showData(newValue)
        }
        get {
            return [:]
        }
    }
    var strTel = ""
    var strCel = ""
    var strEml = ""

    @IBOutlet private var btnTel: UIButton?
    @IBOutlet private var btnSms: UIButton?
    @IBOutlet private var btnVid: UIButton?
    @IBOutlet private var btnEml: UIButton?
    
    weak var delegate: BizCustSubViewDelegate?
    
    private func showData (_ dict: JsonDict) {
        strTel = dict.string("personal_phone")
        strCel = dict.string("mobile_phone")
        strEml = dict.string("email")

        if strTel.isEmpty {
            strTel = strCel
        }

        btnTel?.isEnabled = strTel.isEmpty ? false : true
        btnSms?.isEnabled = strCel.isEmpty ? false : true
        btnVid?.isEnabled = strCel.isEmpty ? false : true
        btnEml?.isEnabled = strEml.isEmpty ? false : true
    }
    
    //MARK: - tap
    
    @IBAction func sendSms () {
        UIMessageClass.sendSMS(to: strCel)
    }
    
    @IBAction func openCall () {
        let s = strCel.isEmpty ? strTel : strCel
        UIMessageClass.openCall(to: s)
    }
    
    @IBAction func openVideoCall () {
        UIMessageClass.openVideoCall(to: strCel)
    }
    
    @IBAction func sendEmail () {
        UIMessageClass.sendEmail(to: strEml)
    }
}




