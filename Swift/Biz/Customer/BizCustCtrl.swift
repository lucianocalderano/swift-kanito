//
//  BizCustCtrl
//  Kanito
//
//  Created by Luciano Calderano on 13/12/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

class BizCustCtrl : MYViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var txtSrch: UITextField!
    
    private var subCellListCust: BizCustSubView? = nil
    private let subTemp: BizCustSubView? = nil
    private var refreshControl: UIRefreshControl!

    private let imageSwipe = UIImage.init(named: "AnchorSx")
    private var idxPrev: IndexPath?
    private var fullArray = [JsonDict]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.loadData), for: .valueChanged)
        self.tableView.addSubview(refreshControl)

        let swipeSx = UISwipeGestureRecognizer.init(target: self, action: #selector(self.swipe))
        swipeSx.direction = .left
        self.tableView.addGestureRecognizer(swipeSx)
        
        let swipeDx = UISwipeGestureRecognizer.init(target: self, action: #selector(self.swipe))
        swipeDx.direction = .right
        self.tableView.addGestureRecognizer(swipeDx)

        self.loadData()
    }
    
    func loadData() {
        refreshControl.endRefreshing()
        let request =  MYHttpRequest.biz("retrive-customers-list")
        request.json = [
            "biz_id"     : UserClass().userId,
            "lang_code"  : getLangCodeForType(.code),
            "page"       : 1,
            "maxrecords" : 9,
        ]
        request.start() { (success, response) in
            if success {
                self.httpResponse(response)
            }
        }
    }
    private func httpResponse(_ resultDict: JsonDict) {
        fullArray = resultDict.array ("customers_list") as! [JsonDict]
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
        return 95
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BizCustCell.dequeue(tableView: tableView, indexPath: indexPath)
        cell.dict = self.dataArray[indexPath.row] as! JsonDict
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let ctrl = BizCustDettCtrl.instanceFromSb(self.storyboard)
        let dict = self.dataArray[indexPath.row] as! JsonDict
        ctrl.strCustId = dict.int("id")
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
            let predicate = NSPredicate.init(format: "%K contains[cd] %@", "full_name", txtSrch.text!)
            self.dataArray = self.fullArray.filter { predicate.evaluate(with: $0) };
        }
        self.tableView.reloadData()
    }
    
    // MARK: swipe
    
    func swipe (sender: UISwipeGestureRecognizer) {
        let p = sender.location(in: self.tableView)
        let currentIdx = self.tableView.indexPathForRow(at: p)

        if sender.direction == .right && self.idxPrev == currentIdx {
            return
        }
        
        if self.idxPrev != nil {
            let cell = self.tableView.cellForRow(at: self.idxPrev!) as! BizCustCell
            self.rotateImage(cell, orientation: .upMirrored)
            
            self.swipeSx (cell)
            self.idxPrev = nil
        }

        if sender.direction == .right {
            self.idxPrev = currentIdx
            
            let cell = self.tableView.cellForRow(at: self.idxPrev!) as! BizCustCell
            self.rotateImage(cell, orientation: .downMirrored)
            
            self.swipeDx (cell)
        }
    }

    private func swipeSx (_ cell: BizCustCell) {
        if self.subCellListCust == nil {
            return
        }
        UIView.animate(withDuration: 0.2, animations: {
            var rect = self.subCellListCust?.view.frame
            rect?.origin.x = -(self.subCellListCust?.view.frame.size.width)!
            self.subCellListCust?.view.frame = rect!
            
            rect = cell.frame
            rect?.origin.x = 0
            cell.frame = rect!
        }, completion: { finished in
            self.subCellListCust?.view.removeFromSuperview()
            self.subCellListCust = nil;
        })
    }

    private func swipeDx (_ cell: BizCustCell) {
        let subTemp = BizCustSubView.instanceFromSb(self.storyboard)
        
        var rect = subTemp.view.frame
        rect.origin.x = -rect.size.width
        rect.origin.y = cell.frame.origin.y
        subTemp.view.frame = rect
        
        self.tableView.addSubview (subTemp.view)
        
        UIView.animate(withDuration: 0.2, animations: {
            var rect = subTemp.view.frame
            rect.origin.x = 0
            subTemp.view.frame = rect
            
            rect = cell.frame;
            rect.origin.x = subTemp.view.frame.size.width
            cell.frame = rect
            
        }, completion: { finished in
            self.subCellListCust = subTemp
            let row = self.idxPrev?.row
            self.subCellListCust?.dict = self.dataArray[row!] as! JsonDict
        })
    }
    
    private func rotateImage (_ cell: BizCustCell, orientation: UIImageOrientation) {
        cell.imvSwipe.image = UIImage(cgImage: (cell.imvSwipe.image?.cgImage)!, scale: 1.0, orientation: orientation)
    }
}
