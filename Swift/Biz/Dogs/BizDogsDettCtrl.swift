//
//  BizCustDettCtrl
//  Kanito
//
//  Created by Luciano Calderano on 13/12/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

class BizDogsDettCtrl : MYViewController, UITableViewDelegate, UITableViewDataSource {
    class func instanceFromSb (_ sb: UIStoryboard!) -> BizDogsDettCtrl {
        return sb.instantiateViewController(withIdentifier: "BizDogsDettCtrl") as! BizDogsDettCtrl
    }
    
    var dogId = 0

    @IBOutlet private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        self.loadData()
    }
    
    func loadData() {
        let request =  MYHttpRequest.biz("retrive-dog-details")
        request.json = [
            "dog_id"    : self.dogId,
            "lang_code" : getLangCodeForType(.code),
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
        
        let dict = resultDict.dictionary("dog_details.Dog")
        self.myNavigationBar?.titolo = dict.string("name")
        
        self.dataArray = DogInfo.data(dict)
        
        let request =  MYHttpRequest.biz("retrive-customer-details")
        request.json = [
            "customer_id" : dict.string("customer_id"),
            "lang_code"   : getLangCodeForType(.code),
        ]
        request.start() { (success, response) in
            if success {
                self.httpResponseCustomer(response)
            }
        }
        self.tableView.reloadData()
    }
    
    private func httpResponseCustomer(_ resultDict: JsonDict) {
        for array in DogInfo.cust (resultDict.dictionary("customer_details.Customer")) {
            self.dataArray.append (array)
        }
        self.tableView.reloadData()
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
            if array[1].isEmpty == false {
                return 60
            }
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
        cell.textLabel?.font = UIFont.mySize(14)
        cell.textLabel?.textAlignment = NSTextAlignment.left
        
        switch array[0] {
        case "Title":
            cell.textLabel?.text = array[1]
            cell.textLabel?.textColor = UIColor.myBlueLight
            
        case "Owner":
            cell.textLabel?.text = array[1].uppercased()
            cell.textLabel?.font = UIFont.mySize(20)
            cell.textLabel?.textColor = UIColor.myBlueLight
            cell.textLabel?.textAlignment = .center

        case "Desc", "Note" :
            cell.textLabel?.text = array[1]
            cell.textLabel?.textColor = UIColor.myMenuSel
            cell.textLabel?.font = UIFont.mySize(16)
        case "-":
            cell.backgroundColor = UIColor.myGreyLight
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        return
    }
    
    private func attrText (img: UIImage, txt: String) -> NSAttributedString {
        let imageAttach = NSTextAttachment()
        imageAttach.image =  img

        let str = NSMutableAttributedString(attributedString: NSAttributedString(attachment: imageAttach))
        let txt = NSMutableAttributedString(attributedString: NSAttributedString(string:" " + txt))
        
        str.append(txt)
        return str
    }
    
    class DogInfo: UITableView {
        class func data (_ dict: JsonDict) -> Array<Any> {
            var array = [[String]]()
            
            array.append(["Title", Lng("dogsDett.Breed1") ])
            array.append(["Desc", dict.string("primary_breed") ])
            array.append(["-" ])
            
            array.append(["Title", Lng("dogsDett.Breed2") ])
            array.append(["Desc", dict.string("secondary_breed") ])
            array.append(["-" ])
            
            array.append(["Title", Lng("gender") ])
            array.append(["Desc", dict.string("gender") ])
            array.append(["-" ])
            
            array.append(["Title", Lng("dogsDett.LessLevel") ])
            array.append(["Desc", dict.string("lessons_level") ])
            array.append(["-" ])
            
            array.append(["Title", Lng("dogsDett.Microchip") ])
            array.append(["Desc", dict.string("microchip") ])
            array.append(["-" ])
            
            array.append(["Title", Lng("dogsDett.BirthDay") ])
            array.append(["Desc", dict.string("birthday") ])
            array.append(["-" ])
            
            array.append(["Title", Lng("dogsDett.DogSize") ])
            array.append(["Desc", dict.string("size") ])
            array.append(["-" ])
            
            array.append(["Title", Lng("dogsDett.DogMood") ])
            array.append(["Desc", dict.string("mood") ])
            array.append(["-" ])
            
            array.append(["Note", dict.string("note") ])
            
            return array
        }
        
        class func cust (_ dict: JsonDict) -> Array<Any> {
            var array =  [[String]]()

            array.append(["Owner", dict.string("name") + " " + dict.string("last_name") ])
            array.append(["-" ])
            
            array.append(["Title", Lng("phone") ])
            array.append(["Desc", dict.string("mobile_phone") ])
            array.append(["-" ])

            array.append(["Title", Lng("email") ])
            array.append(["Desc", dict.string("email") ])
            array.append(["-" ])
 
            return array
        }
    }
}
