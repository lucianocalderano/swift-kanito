//
//  RegistrationSubView
//  Kanito
//
//  Created by Luciano Calderano on 28/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit


protocol BizMainDataSubViewDelegate : class {
    func bizMainDataViewTappedItem (item: Int)
}

class BizMainDataSubView : UIView {
    
    @IBOutlet var v0: UIView!
    @IBOutlet var v1: UIView!
    @IBOutlet var v2: UIView!
    @IBOutlet var v3: UIView!

    @IBOutlet private var lblNumCust: MYLabel!
    @IBOutlet private var lblNumDogs: MYLabel!
    @IBOutlet private var lblPayToday: MYLabel!
    @IBOutlet private var lblPayMonth: MYLabel!
    
    weak var delegate: BizMenuSubViewDelegate?
    
    override func awakeFromNib () {
        super.awakeFromNib()
        
        self.v0.layer.cornerRadius = self.v0.frame.size.width / 2;
        self.v1.layer.cornerRadius = self.v1.frame.size.width / 2;
        self.v2.layer.cornerRadius = self.v2.frame.size.width / 2;
        self.v3.layer.cornerRadius = self.v3.frame.size.width / 2;
        
        
        let tapCust = UITapGestureRecognizer.init(target: self, action: #selector(custTapped))
        self.v0.addGestureRecognizer(tapCust)
        self.v0.isUserInteractionEnabled = true

        let tapDogs = UITapGestureRecognizer.init(target: self, action: #selector(dogsTapped))
        self.v1.addGestureRecognizer(tapDogs)
        self.v1.isUserInteractionEnabled = true
        
        self.lblNumCust.text = "000"
        self.lblNumDogs.text = "000"
        
        _ = Counter(custLabel: self.lblNumCust, dogsLabel: self.lblNumDogs)
    }

    func custTapped () {
        self.delegate?.menuButtonTapped(item: ItemMenu.Cust.hashValue)
    }

    func dogsTapped () {
        self.delegate?.menuButtonTapped(item: ItemMenu.Dog.hashValue)
    }
    
    func updateFinancialWithDic (_ dicResult: JsonDict) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal;
        formatter.maximumSignificantDigits = 6
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        formatter.usesSignificantDigits = false
        formatter.usesGroupingSeparator = true
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","
        
        let a = NSNumber (floatLiteral: dicResult.double("payment_today"))
        let b = NSNumber (floatLiteral: dicResult.double("payment_month"))
        
        self.lblPayToday.text = formatter.string(from: a)! + "€"
        self.lblPayMonth.text = formatter.string(from: b)! + "€"
    }
}

class Counter {
    private let mainKey = "Setting"
    private let keyCust = "Cust"
    private let keyDogs = "Dogs"
    private var dict: JsonDict?
    
    init (custLabel: MYLabel, dogsLabel: MYLabel) {
        self.loadCust(label: custLabel)
        self.loadDogs(label: dogsLabel)
        dict = UserDefaults.standard.object(forKey: mainKey) as! JsonDict?
        guard dict != nil else {
            self.dict = JsonDict()
            custLabel.text = "0"
            dogsLabel.text = "0"
            return
        }
        custLabel.text = dict?.string(keyCust)
        dogsLabel.text = dict?.string(keyDogs)
    }
    
    private func loadCust(label: MYLabel) {
        let request =  MYHttpRequest.biz("retrive-customers-number")
        request.json = [
            "biz_id"     : UserClass().userId,
        ]
        request.start(showWheel: false) { (success, response) in
            if success {
                label.text = response.string("customers_number")
                self.dict?[self.keyCust] = label.text
                UserDefaults.standard.set(self.dict, forKey: self.mainKey)
            }
        }
    }
    
    private func loadDogs(label: MYLabel) {
        let request =  MYHttpRequest.biz("retrive-dogs-number")
        request.json = [
            "biz_id"     : UserClass().userId,
        ]
        request.start(showWheel: false) { (success, response) in
            if success {
                label.text = response.string("dogs_number")
                self.dict?[self.keyDogs] = label.text
                UserDefaults.standard.set(self.dict, forKey: self.mainKey)
            }
        }
    }
}


