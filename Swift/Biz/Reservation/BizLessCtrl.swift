//
//  BizCustDettCtrl
//  Kanito
//
//  Created by Luciano Calderano on 13/12/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

class BizLessCtrl : MYViewController, UITableViewDelegate, UITableViewDataSource {
    enum LessType {
        case Sng
        case Grp        
    }
    
    class func instanceFromSb (_ sb: UIStoryboard!) -> BizLessCtrl {
        return sb.instantiateViewController(withIdentifier: "BizLessCtrl") as! BizLessCtrl
    }
    
    let weekTime = 7 * 60 * 60 * 24
    
    private var datIni = Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
    
    private var lessType = LessType.Sng
    private var refreshControl: UIRefreshControl!

    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var btnSng: UIButton!
    @IBOutlet private var btnGrp: UIButton!
    @IBOutlet private var lblDat: UILabel!
    
    private var lessonsDict = [String: Any]()

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        self.tableView.addSubview(refreshControl)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        self.sngLess()
    }
    
    func refresh () {
        self.lessonsDict.removeValue (forKey: self.keyDict())
        refreshControl.endRefreshing()
        self.loadData()
    }
    
    private func keyDict () -> String {
        return self.datIni.toString(DateFormat.fmtDbShort.rawValue) + ":" + String(self.lessType.hashValue)
    }
    
    private func loadData() {
        let datFin = Calendar.current.date(byAdding: .day, value: 6, to: self.datIni)!
        lblDat.text = datIni.toString(DateFormat.fmtData.rawValue) +
              " - " + datFin.toString(DateFormat.fmtData.rawValue)

        if self.lessonsDict[self.keyDict()] != nil {
            self.dataArray = self.lessonsDict.array(self.keyDict())
            self.tableView.reloadData()
            return;
        }
        
        let page = (lessType == .Sng) ? "retrive-single-lessons" : "retrive-group-lessons"

        let request =  MYHttpRequest.biz(page)
        request.json = [
            "biz_id"     : UserClass().userId,
            "start_date" : datIni.toString(DateFormat.fmtDbShort.rawValue),
            "end_date"   : datFin.toString(DateFormat.fmtDbShort.rawValue),
        ]
        request.start() { (success, response) in
            if success {
                self.httpResponse(response)
            }
        }
    }
    
    private func httpResponse(_ resultDict: JsonDict) {
        let key = (self.lessType == .Sng) ? "single_lessons" : "group_lessons"
        self.dataArray = Lessons.sngLess(resultDict.array(key) as! [JsonDict])
        self.lessonsDict[self.keyDict()] = self.dataArray
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
        cell.backgroundColor = UIColor.white
        
        switch array[0] {
        case "Date":
            cell.textLabel?.text = array[1]
            cell.textLabel?.font = UIFont.mySize(20)
            cell.textLabel?.textColor = UIColor.white
            cell.textLabel?.textAlignment = NSTextAlignment.center
//            let colorString = "0x" + array[2]
//            var rgbValue:UInt32 = 0
//            Scanner(string: colorString).scanHexInt32(&rgbValue)
//            let color =  UIColor.init(netHex: Int(rgbValue))
//            cell.backgroundColor = color
            cell.backgroundColor = UIColor.myMenuBkg
            
        case "Time":
            cell.textLabel?.text = array[1].uppercased()
            cell.textLabel?.font = UIFont.mySize(18)
            cell.textLabel?.textColor = UIColor.myBlueLight

        case "Title" :
            cell.textLabel?.text = "  " + array[1]
            cell.textLabel?.textColor = UIColor.myMenuSel
            cell.textLabel?.font = UIFont.mySize(16)
            
        case "Dog" :
            cell.textLabel?.text = "  - " + array[1]
            cell.textLabel?.textColor = UIColor.myMenuSel
            cell.textLabel?.font = UIFont.mySize(14)
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
    
    @IBAction func sngLess () {
        btnSng.backgroundColor = UIColor.white
        btnSng.setTitleColor(UIColor.myBlueLight, for: .normal)
        btnGrp.backgroundColor = UIColor.myBlueLight
        btnGrp.setTitleColor(UIColor.white, for: .normal)
        self.lessType = .Sng
        self.loadData()
    }

    @IBAction func grpLess () {
        btnSng.backgroundColor = UIColor.myBlueLight
        btnSng.setTitleColor(UIColor.white, for: .normal)
        btnGrp.backgroundColor = UIColor.white
        btnGrp.setTitleColor(UIColor.myBlueLight, for: .normal)
        self.lessType = .Grp
        self.loadData()
    }
    
    @IBAction func prevWeek () {
        datIni = datIni.addingTimeInterval(TimeInterval( -weekTime ))
        self.loadData()
    }
    @IBAction func nextWeek () {
        datIni = datIni.addingTimeInterval(TimeInterval( +weekTime ))
        self.loadData()
    }
    
    class Lessons: UITableView {
        class func sngLess (_ lessArray: [JsonDict]) -> Array<Any> {
            var array =  [[String]]()
            if lessArray.isEmpty {
                return array
            }
            
            for dictLess in lessArray {
                let date = dictLess.string("SpcEvent.start_date").dateFmt(fmtIn: .fmtDbShort, fmtOut: .fmtData)
                array.append(["Date", date, dictLess.string("SpcEvent.color") ])
                array.append(["Time", dictLess.string("SpcEvent.start_time") +
                    " - " + dictLess.string("SpcEvent.end_time")])

                var title = dictLess.string("SpcEvent.title") + " (with"
                for dict in dictLess.array("Trainers") as! [JsonDict] {
                    title += " " + dict.string("name") + ","
                }

                title = String(title.characters.dropLast()) + ")"
                array.append(["Title", title ])
                
                for dict in dictLess.array("Participants") as! [JsonDict] {
                    array.append(["Dog",
                        dict.string("Customer.customer_name") + " " +
                        dict.string("Customer.customer_last_name") + " with " +
                        dict.string("Dog.dog_name")])
                }
               array.append([" " ])
            }
            return array
        }
    }
}
