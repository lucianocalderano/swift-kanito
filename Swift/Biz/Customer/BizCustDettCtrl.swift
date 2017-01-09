//
//  BizCustDettCtrl
//  Kanito
//
//  Created by Luciano Calderano on 13/12/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

class BizCustDettCtrl : MYViewController, UITableViewDelegate, UITableViewDataSource {
    class func instanceFromSb (_ sb: UIStoryboard!) -> BizCustDettCtrl {
        return sb.instantiateViewController(withIdentifier: "BizCustDettCtrl") as! BizCustDettCtrl
    }
    
    var strCustId = 0

    @IBOutlet private var tableView: UITableView!

    @IBOutlet var viewFoot: UIView?
    @IBOutlet var viewBody: UIView?
    @IBOutlet var imvPicCust: UIImageView?

    @IBOutlet var btnInfo: MYButton?
    @IBOutlet var btnDogs: MYButton?
    @IBOutlet var btnRese: MYButton?

    @IBOutlet var btnTel: MYButton?
    @IBOutlet var btnSms: MYButton?
    @IBOutlet var btnVid: MYButton?
    @IBOutlet var btnEml: MYButton?

    @IBOutlet var btnSel: MYButton?
    
    private var strTel = ""
    private var strCel = ""
    private var strEml = ""

//    ClsCellUtil  *clsCellUtil;
    
//    BizCustDettInfoScrl *scrlInfo;
//    BizCustDettLessScrl *scrlLess;
//    BizCustDettDogsTbl *tblvDogs;
    
    var arrBtn = [MYButton]()
    var arrSub = [UIView]()
    var dicCust = JsonDict()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        btnInfo?.setTitle(Lng("custDett.Data"), for: .normal)
        btnDogs?.setTitle(Lng("custDett.Dogs"), for: .normal)
        btnRese?.setTitle(Lng("custDett.Rese"), for: .normal)
        btnInfo?.tag = 0
        btnDogs?.tag = 1
        btnRese?.tag = 2

        self.loadData()
    }
    
    func loadData() {
        let request =  MYHttpRequest.biz("retrive-customer-details")
        request.json = [
            "customer_id" : self.strCustId,
            "lang_code"   : getLangCodeForType(.code),
        ]
        request.start() { (success, response) in
            if success {
                self.httpResponse(response)
            }
        }
    }
    
    private func httpResponse(_ resultDict: JsonDict) {
        if resultDict.isEmpty {
            return
        }
        self.dicCust = resultDict.dictionary("customer_details.Customer")

        var rect = viewBody?.frame
        rect?.origin = CGPoint.zero
        self.showView(0)
        
        self.myNavigationBar?.titolo = self.dicCust.string("last_name") + " " + self.dicCust.string("name")
        
        let arr = self.dicCust.array("dogs")
        let s = Lng("custDett.Dogs") + " (" + String (arr.count) + ")"
        btnDogs?.setTitle(s, for: .normal)
        
        strTel = self.dicCust.string("personal_phone")
        strCel = self.dicCust.string("mobile_phone")
        strEml = self.dicCust.string("email")
        if strTel.isEmpty {
            strTel = strCel
        }

        btnTel?.isEnabled = strTel.isEmpty ? false : true
        btnSms?.isEnabled = strCel.isEmpty ? false : true
        btnVid?.isEnabled = strTel.isEmpty ? false : true
        btnEml?.isEnabled = strEml.isEmpty ? false : true
        
        imvPicCust?.image = UIImage.init(named: "icoUserPerInfo")
        imvPicCust?.imageFromUrl(self.dicCust.string("image"))
    }
    
    // MARK: table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let array = self.dataArray[indexPath.row] as! [String]
        switch array[0] {
        case "-":
            return 1
        case "Note":
            return 100
        default:
            break
        }
        return 25
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        let array = self.dataArray[indexPath.row] as! [String]

        cell.backgroundColor = UIColor.white
        cell.accessoryType = UITableViewCellAccessoryType.none
        cell.textLabel?.font = UIFont.mySize(16)
        cell.textLabel?.textAlignment = NSTextAlignment.left
        
        switch array[0] {
        case "Title":
            var img: UIImage?
            if array[1].isEmpty == false {
                img = UIImage.init(named: array[1])
            }
            if img != nil {
                cell.textLabel?.attributedText = self.attrText(img: (img?.resize(newWidth: 16))!, txt: array[2])
            }
            else {
                cell.textLabel?.text = array[2]
            }
            cell.textLabel?.textColor = UIColor.myBlueLight
        case "Desc", "Note" :
            cell.textLabel?.text = array[1]
            cell.textLabel?.textColor = UIColor.myMenuSel
        case "DogN":
            cell.textLabel?.text = array[1]
            cell.textLabel?.textColor = UIColor.myMenuSel
        case "DogB":
            cell.textLabel?.text = array[1]
            cell.textLabel?.textColor = UIColor.myBlueLight
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        case "-":
            cell.backgroundColor = UIColor.myGreyLight
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let array = self.dataArray[indexPath.row] as! [String]
        switch array[0] {
        case "DogN", "DogB":
            let sb = UIStoryboard.init(name: "BizDogs", bundle: nil)
            let ctrl = BizDogsDettCtrl.instanceFromSb(sb)
            ctrl.dogId = Int(array[2])!
            self.navigationController?.show(ctrl, sender: self)
            return
        default:
            break
        }
        return
    }
    
    @IBAction func btnShowView (_ sender: MYButton) {
        self.showView(sender.tag)
    }

    private func showView (_ viewNumber: Int) {
        switch viewNumber {
        case 0:
            self.dataArray = CustomerInfo.data(self.dicCust)
        case 1:
            self.dataArray = CustomerInfo.dogs(self.dicCust)
        case 2:
            self.dataArray = CustomerInfo.rese(self.dicCust)
        default:
            return
        }
        self.tableView.reloadData()
    }
    
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
        UIMessageClass.sendEmail(to: strCel)
    }
    
    private func attrText (img: UIImage, txt: String) -> NSAttributedString {
        let imageAttach = NSTextAttachment()
        imageAttach.image =  img

        let str = NSMutableAttributedString(attributedString: NSAttributedString(attachment: imageAttach))
        let txt = NSMutableAttributedString(attributedString: NSAttributedString(string:" " + txt))
        
        str.append(txt)
        return str
    }
    
    class CustomerInfo: UITableView {
        class func data (_ dict: JsonDict) -> Array<Any> {
            var array = [[String]]()
            
            var s = ""
            if dict.string("cap").isEmpty == false {
                s += dict.string("cap") + " - "
            }
            if dict.string("city_name").isEmpty {
                s += dict.string("foreign_city")
            }
            else {
                s += dict.string("city_name")
            }
            
            array.append(["Title", Lng("ClieInd"), "Location" ])
            array.append(["Desc", dict.string("address") ])
            array.append(["Desc", s ])
            array.append(["-" ])
            
            array.append(["Title", Lng("ClieBDy"), "Bday" ])
            array.append(["Desc", dict.string("birthDay") ])
            array.append(["-" ])
            
            array.append(["Title", Lng("ClieCof"), "" ])
            array.append(["Desc", dict.string("fiscal_code") ])
            array.append(["-" ])
            
            array.append(["Title", Lng("ClieDoc"), "" ])
            array.append(["Desc", dict.string("document_type") + " " + dict.string("document_number") ])
            array.append(["-" ])
            
            array.append(["Title", Lng("ClieTel"), "Phone" ])
            array.append(["Desc", dict.string("personal_phone") ])
            array.append(["-" ])
            
            array.append(["Title", Lng("ClieCel"), "Cell" ])
            array.append(["Desc", dict.string("mobile_phone") ])
            array.append(["-" ])
            
            array.append(["Title", Lng("ClieEml"), "Email" ])
            array.append(["Desc", dict.string("email") ])
            array.append(["-" ])
            
            array.append(["Title", Lng("ClieVet"), "" ])
            array.append(["Desc", dict.string("veterinary_full_name") + " " + dict.string("veterinary_phone") ])
            array.append(["-" ])
            
            array.append(["Note", dict.string("notes") ])
            
            return array
        }
        
        class func dogs (_ dict: JsonDict) -> Array<Any> {
            var array =  [[String]]()

            for dictDogs in dict.array("dogs") as! [JsonDict] {
                array.append(["DogN", dictDogs.string("name"), dictDogs.string("id") ])
                array.append(["DogB", dictDogs.string("primary_breed_name"), dictDogs.string("id") ])
                array.append(["-" ])
            }
            return array
        }
        
        class func rese (_ dict: JsonDict) -> Array<Any> {
            var array =  [[String]]()
            
            for dictRese in dict.array("reservations") as! [JsonDict] {
                array.append(["Title", Lng("LessTitG"), "" ])
                array.append(["-" ])
                for dic in dictRese.array("group") as! [JsonDict] {
                    let s =
                        dic.string("SpcEvent.SpcCalendar.start_time") + " - " +
                        dic.string("SpcEvent.SpcCalendar.end_time") + " del " +
                        dic.string("Reservation.start_date") + " ! " +
                        dic.string("SpcEvent.name") + " /  " +
                        dic.string("title")
                    array.append(["Desc", s ])
                }
                array.append(["-" ])

                array.append(["Title", Lng("LessTitS"), "" ])
                array.append(["-" ])
                for dic in dictRese.array("single") as! [JsonDict] {
                    let s =
                        dic.string("SpcEvent.start_time") + " - " +
                        dic.string("SpcEvent.end_time") + " del " +
                        dic.string("start_date") + " ! " +
                        dic.string("title")
                    array.append(["Desc", s ])
                }
                array.append(["-" ])
            }
            return array
        }
    }
}
