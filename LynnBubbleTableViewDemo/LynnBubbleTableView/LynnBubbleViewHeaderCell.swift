//
//  LynnBubbleViewHeaderCell.swift
//  To my love Derrick and LynnA
//
//  Created by Lou Hwang on 2015. 10. 30..
//  Copyright © 2015 Lou Hwang. All rights reserved.
//

import UIKit

class LynnBubbleViewHeaderCell: UITableViewCell {

    @IBOutlet weak var lbDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDate(date:NSDate, withDay:Bool) {
        let dateFormatter = NSDateFormatter()
        let stringDate:NSDate = date
        dateFormatter.dateFormat = "yyyy/MM/dd"
        var strDate = dateFormatter.stringFromDate(stringDate)
//        self.lbDate.text = dateFormatter.stringFromDate(stringDate)
        
        if withDay {

            let language = NSBundle.mainBundle().preferredLocalizations.first! as String
            dateFormatter.locale = NSLocale(localeIdentifier: language)
            
            dateFormatter.dateFormat = "EEEEE";
            strDate = strDate + " " + dateFormatter.stringFromDate(date).capitalizedString
        }
        self.lbDate.text = strDate
        
    }
}
