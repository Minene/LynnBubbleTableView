//
//  Someone'sBubbleViewCell.swift
//  To my love Derrick and LynnA
//
//  Created by Lou Hwang on 2015. 10. 30..
//  Copyright © 2015 Lou Hwang. All rights reserved.
//

import UIKit

class Someone_sBubbleViewCell: MyBubbleViewCell {

    @IBOutlet weak var imgProfile: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .None
        self.imgProfile.layer.cornerRadius = 21.5
        self.imgProfile.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
    override func setBubbleData(data: LynnBubbleData) {
        self.imgProfile.image = data.profileImage
        super.setBubbleData(data)
    }
}
