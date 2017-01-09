//
//  BizCustCtrl
//  Kanito
//
//  Created by Luciano Calderano on 13/12/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

class BizDogsCtrl : MYViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var txtSrch: UITextField!
    
    private var refreshControl: UIRefreshControl!

    private var idxPrev: IndexPath?
    private var fullArray = [JsonDict]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.loadData), for: .valueChanged)
        self.tableView.addSubview(refreshControl)

        self.loadData()
    }
    
    func loadData() {
        refreshControl.endRefreshing()
        let request =  MYHttpRequest.biz("retrive-dogs-list")
        request.json = [
            "biz_id"     : UserClass().userId,
            "lang_code"  : getLangCodeForType(.id),
        ]
        request.start() { (success, response) in
            if success {
                self.httpResponse(response)
            }
        }
    }
    private func httpResponse(_ resultDict: JsonDict) {
        fullArray = resultDict.array ("dogs_list") as! [JsonDict]
        self.dataArray = fullArray;

        tableView.reloadData()
    }
    
    // MARK: table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BizDogsCell.dequeue(tableView: tableView, indexPath: indexPath)
        cell.dict = self.dataArray[indexPath.row] as! JsonDict
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let ctrl = BizDogsDettCtrl.instanceFromSb(self.storyboard)
        let dict = self.dataArray[indexPath.row] as! JsonDict
        ctrl.dogId = dict.int("id")
        self.navigationController?.show(ctrl, sender: self)
    }
    
    // MARK: search
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func textSrchChanged () {
        if (txtSrch.text?.isEmpty)! {
            self.dataArray = self.fullArray
            txtSrch.perform(#selector(resignFirstResponder), with: nil, afterDelay: 0.3)
        }
        else {
            let predicate = NSPredicate.init(format:
                "%K contains[cd] %@ OR %K contains[cd] %@ OR %K contains[cd] %@",
                "customer_full_name", txtSrch.text!, "name", txtSrch.text!, "primary_breed", txtSrch.text!)
            
            self.dataArray = self.fullArray.filter { predicate.evaluate(with: $0) };
        }
        self.tableView.reloadData()
    }
}
