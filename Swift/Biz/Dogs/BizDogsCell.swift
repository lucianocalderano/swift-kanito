//
//  BizCustCell
//  Kanito
//
//  Created by Luciano Calderano on 26/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

class BizDogsCell: UITableViewCell {
    class func dequeue (tableView: UITableView, indexPath: IndexPath) -> BizDogsCell {
        return tableView.dequeueReusableCell(withIdentifier: "BizDogsCell", for: indexPath) as! BizDogsCell
    }

    var dict:JsonDict {
        set {
            self.showData(newValue)
        }
        get {
            return [:]
        }
    }
    
    @IBOutlet private var lblNome: MYLabel!
    @IBOutlet private var lblRaz: MYLabel!
    @IBOutlet private var lblSes: MYLabel!
    @IBOutlet private var lblLiv: MYLabel!
    @IBOutlet private var lblSiz: MYLabel!
    @IBOutlet private var lblAge: MYLabel!
    @IBOutlet private var lblMoo: MYLabel!
    @IBOutlet private var imvPic: UIImageView!

    private func showData(_ dictData: JsonDict) -> Void {
        
        let mutableAttr = NSMutableAttributedString()
        mutableAttr.append(NSAttributedString(string: dictData.string("name"),
                                              attributes:[
                                                NSForegroundColorAttributeName: UIColor.myBlueLight,
                                                NSFontAttributeName: UIFont.mySize(16)
            ]))
        mutableAttr.append(NSAttributedString(string: " (di " +  dictData.string("customer_full_name") + ")",
                                              attributes:[
                                                NSForegroundColorAttributeName: UIColor.myGreyDark,
                                                NSFontAttributeName: UIFont.mySize(12)
            ]))

        lblNome.attributedText = mutableAttr
        lblRaz.text = dictData.string("primary_breed")
        lblSes.text = dictData.string("gender")
        lblLiv.text = dictData.string("lessons_level")
        lblAge.text = dictData.string("age")
        lblSiz.text = dictData.string("size")
        lblMoo.text = dictData.string("mood")
        
        imvPic.image = UIImage.init(named: "Cane_cerchio")
        imvPic.imageFromUrl(dictData.string("image"))
    }
}
