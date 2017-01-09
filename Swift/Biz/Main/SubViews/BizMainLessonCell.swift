//
//  BizMainCell
//  Kanito
//
//  Created by Luciano Calderano on 26/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

class BizMainLessonCell: UITableViewCell {
    class func dequeue (tableView: UITableView, indexPath: IndexPath) -> BizMainLessonCell {
        return tableView.dequeueReusableCell(withIdentifier: "BizMainLessonCell", for: indexPath) as! BizMainLessonCell
    }

    private var lessonClass:LessonClass?
    var lesson:LessonClass {
        set {
            self.showData(newValue)
        }
        get {
            return self.lessonClass!
        }
    }
    
    @IBOutlet private var timeLabel: MYLabel!
    @IBOutlet private var nameLabel: MYLabel!

    private func showData(_ lesson: LessonClass) -> Void {
        self.lessonClass = lesson
        timeLabel.text = lesson.strTime;
        timeLabel.text = lesson.strName + " " + Lng("with") + lesson.strCustName
    }
}
