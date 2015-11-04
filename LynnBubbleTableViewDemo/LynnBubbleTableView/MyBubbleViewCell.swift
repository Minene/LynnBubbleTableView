//
//  MyBubbleViewCell.swift
//  To my love Derrick and LynnA
//
//  Created by Lou Hwang on 2015. 10. 30..
//  Copyright © 2015 Lou Hwang. All rights reserved.
//

import UIKit

class MyBubbleViewCell: UITableViewCell {

    @IBOutlet weak var lbText: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setBubbleData(data:LynnBubbleData) {
        
        self.lbText.text = data.text
        self.lbTime.text = self.getTimeString(data.date!)
        
    }
    
    func getTimeString(date:NSDate) -> String {
    
        let dateFormatter = NSDateFormatter()
        let language = NSBundle.mainBundle().preferredLocalizations.first! as String
        dateFormatter.locale = NSLocale(localeIdentifier: language)
        let stringDate:NSDate = date
        dateFormatter.dateFormat = "a h:mm"
        return dateFormatter.stringFromDate(stringDate)
    }
    
}
