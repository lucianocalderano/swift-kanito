//
//  BizCustCell
//  Kanito
//
//  Created by Luciano Calderano on 26/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

class BizCustCell: UITableViewCell {
    class func dequeue (tableView: UITableView, indexPath: IndexPath) -> BizCustCell {
        return tableView.dequeueReusableCell(withIdentifier: "BizCustCell", for: indexPath) as! BizCustCell
    }

    var dict:JsonDict {
        set {
            self.showData(newValue)
        }
        get {
            return [:]
        }
    }
    @IBOutlet var imvSwipe: UIImageView!
    
    @IBOutlet private var lblNom: MYLabel!
    @IBOutlet private var lblTel: MYLabel!
    @IBOutlet private var lblDeb: MYLabel!
    @IBOutlet private var lblInv: MYLabel!
    @IBOutlet private var lblEml: MYLabel!
    @IBOutlet private var lblMem: MYLabel!
    @IBOutlet private var imvCustomer: UIImageView!

    private func showData(_ dicCust: JsonDict) -> Void {
        let strTel = dicCust.string("personal_phone")
        let strCel = dicCust.string("mobile_phone")
        
        lblTel.text = strTel;
        if strTel.isEmpty {
            lblTel.text = strCel
        }
        else if strCel.isEmpty == false {
            lblTel.text = strTel + " / " + strCel
        }

        lblNom.text = " " + dicCust.string("full_name")
        lblEml.text = dicCust.string("email")
        
        lblDeb.isHidden = true
        let i = dicCust.int("totalDebts")
        lblDeb.text = String(i)
        
        lblInv.text = dicCust.string("invitation_status")
        lblMem.text = dicCust.string("memberCardStatus")
        imvCustomer.image = UIImage.init(named: "customer")
        imvCustomer.imageFromUrl(dicCust.string("image"))
    }
}
