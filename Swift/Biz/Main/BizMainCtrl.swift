//
//  BizMainCtrl
//  Kanito
//
//  Created by Luciano Calderano on 26/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit


class BizMainCtrl: MYViewController, UITableViewDelegate, UITableViewDataSource, BizMenuSubViewDelegate {
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var bizHomeDataView: BizMainDataSubView?
    @IBOutlet private var bizMenuView: BizMenuSubView?
    @IBOutlet private var mainView: UIView?

    private var refreshControl = UIRefreshControl()
    
    private var arrDebt = [JsonDict]()
    private var arrTask = [JsonDict]()
    private var arrLessSng = [LessonClass]()
    private var arrLessGrp = [LessonClass]()
    private let arrImg = [
            UIImage.init(named: "icoImportantOk")?.resize(newWidth: 16)!,
            UIImage.init(named: "icoImportantNo")?.resize(newWidth: 16)!
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.loadData), for: .valueChanged)
        self.tableView.addSubview(refreshControl)

        self.myNavigationBar?.barTintColor = UIColor.myBlueLight
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        self.bizMenuView = BizMenuSubView.InstanceInto(self.bizMenuView!)
        self.bizMenuView?.addMenuInView(mainView: self.view)
        
        self.bizMenuView?.delegate = self
        self.bizHomeDataView?.delegate = self
        
        self.loadData()
    }
    
    override func myNavigatorOptionButtonTapped() {
        self.bizMenuView?.moveMenu()
    }

    func menuButtonTapped (item: Int) {
        var sbName = ""
        switch item {
        case ItemMenu.Dash.hashValue:
            return
        case ItemMenu.Cust.hashValue:
            sbName = "BizCust"
        case ItemMenu.Dog.hashValue:
            sbName = "BizDogs"
            break
        case ItemMenu.Less.hashValue:
            sbName = "BizLess"
            break
        case ItemMenu.Home.hashValue:
            _ = self.navigationController?.popToRootViewController(animated: true)
            return
        case ItemMenu.Logout.hashValue:
            UserClass().logout()
            _ = self.navigationController?.popToRootViewController(animated: true)
            return
        default:
            return
        }
        
        let sb = UIStoryboard.init(name: sbName, bundle: nil)
        let ctrl = sb.instantiateInitialViewController()
        self.navigationController?.show(ctrl!, sender: self)
        self.bizMenuView?.closeMenu()
    }

    func loadData() {
        refreshControl.endRefreshing()
        let request =  MYHttpRequest.biz("retrive-dashboard-data")
        request.json = [
            "biz_id" : UserClass().userId,
        ]
        request.start() { (success, response) in
            if success {
                self.httpResponse(response)
            }
        }
    }
    private func httpResponse(_ resultDict: JsonDict) {
        arrDebt = resultDict.array("latest_debts") as! [JsonDict]
        arrTask = resultDict.array("tasks") as! [JsonDict]
        arrLessSng = LessonClass.buildArrSng(resultDict)
        arrLessGrp = LessonClass.buildArrGrp(resultDict)

        bizHomeDataView?.updateFinancialWithDic (resultDict)

        tableView.reloadData()
    }
    
    // MARK: table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 28
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = MYLabel()
        
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.mySize(18)
        label.textColor = UIColor.darkGray
        switch (section) {
        case 0:
            label.backgroundColor = bizHomeDataView?.v0.backgroundColor
            label.title = "#dashboard.Task"
        case 1:
            label.backgroundColor = bizHomeDataView?.v1.backgroundColor;
            label.title = "#dashboard.ResS"
        case 2:
            label.backgroundColor = bizHomeDataView?.v2.backgroundColor;
            label.title = "#dashboard.ResG"
        case 3:
            label.backgroundColor = bizHomeDataView?.v3.backgroundColor;
            label.title = "#dashboard.Debt"
        default:
            break
        }
        return label;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return (arrTask.count == 0) ? 1 : arrTask.count
        case 1:
            return (arrLessSng.count == 0) ? 1 : arrLessSng.count
        case 2:
            return (arrLessGrp.count == 0) ? 1 : arrLessGrp.count
        case 3:
            return arrDebt.count
        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch (indexPath.section) {
        case 0:
            return self.cellTask (indexPath.row)
        case 1:
            return self.cellLess (indexPath, array: arrLessSng)
        case 2:
            return self.cellLess (indexPath, array: arrLessGrp)
        case 3:
            return self.cellDebt (indexPath.row)
        default:
            break
        }
        return self.noCellWithTitle("Section: \(indexPath.section) ???")
    }
    
    private func cellTask(_ row: Int) -> UITableViewCell {
        if (arrTask.count == 0) {
            return self.noCellWithTitle(Lng("TaskNone"))
        }
        else {
            return self.dashCellWithDic(arrTask[row])
        }
    }

    private func dashCellWithDic(_ dic: JsonDict) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        cell.textLabel?.text = dic.string("Task.task")
        cell.textLabel?.font = UIFont.mySize(16)
        cell.textLabel?.textColor = UIColor.myBlueLight
        cell.textLabel?.textAlignment = NSTextAlignment.center
        cell.detailTextLabel?.text = ""
        cell.imageView?.image =  dic.int("Task.important") == 1 ? arrImg[0] : arrImg[1]
        return cell
    }

    private func cellLess(_ indexPath: IndexPath, array:Array<LessonClass>) -> UITableViewCell {
        if (arrTask.count == 0) {
            return self.noCellWithTitle(Lng("TaskNone"))
        }
        let cell = BizMainLessonCell.dequeue(tableView: self.tableView, indexPath: indexPath)
        cell.lesson = array[indexPath.row]
        return cell
    }
    private func cellDebt(_ row: Int) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "Cell")
        let dic = arrDebt[row]
        
        cell.textLabel?.text = dic.string("Customer.name") + " " + dic.string("Customer.last_name")
        cell.textLabel?.font = UIFont.mySize(15)
        cell.textLabel?.textColor = UIColor.myBlueLight
        cell.textLabel?.textAlignment = NSTextAlignment.center
        
        cell.detailTextLabel?.text = "x" + dic.string("debt_number")
        cell.textLabel?.textColor = UIColor.darkGray
        cell.textLabel?.font = UIFont.mySize(15)

        cell.imageView?.image = UIImage.init(named: "Monete")?.resize(newWidth: 16)
        return cell
    }

    private func noCellWithTitle(_ title: String) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        cell.textLabel?.text = title
        cell.textLabel?.font = UIFont.mySize(16)
        cell.textLabel?.textColor = UIColor.gray
        cell.textLabel?.textAlignment = NSTextAlignment.center
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: LessonClass
    
class LessonClass {
    var strTime = ""
    var strName = ""
    var strCustName = ""
    init(time: String, dogName: String, userName: String, userLastName: String) {
        self.strTime = time
        self.strName = dogName
        self.strCustName = userName + " " + userLastName

    }
    
    class func buildArrSng(_ dict: JsonDict) -> Array<LessonClass> {
        let array = dict.array("today_single_reservations") as! [JsonDict]
        var arrTmp = [LessonClass]()
        for dic in array as [JsonDict] {
            let s = dic.string("SpcEvent.start_time") +
                " - " +  dic.string("SpcEvent.end_time") +
                " - " +  dic.string("SpcEvent.title")
            
            for dicDog in dic.array("Dog") as! Array<JsonDict> {
                let lesson = LessonClass.init(time: s,
                                              dogName: dicDog.string("name"),
                                              userName: dicDog.string("Customer.name"),
                                              userLastName: dicDog.string("Customer.last_name"))
                arrTmp.append(lesson)
            }
        }
        return arrTmp
    }

    class func buildArrGrp(_ dict: JsonDict) -> Array<LessonClass> {
        let array = dict.array("today_group_reservations") as! [JsonDict]
        var arrTmp = [LessonClass]()
        for dic in array as [JsonDict] {
            let s = dic.string("SpcEvent.start_time") +
                " - " +  dic.string("SpcEvent.end_time") +
                " - " +  dic.string("SpcEvent.title")
            
            let lesson = LessonClass.init(time: s,
                                          dogName: dic.string("Dog.name"),
                                          userName: dic.string("SpcEvent.Customer.name"),
                                          userLastName: dic.string("SpcEvent.Customer.last_name"))
            arrTmp.append(lesson)
        }
        return arrTmp
    }
}
