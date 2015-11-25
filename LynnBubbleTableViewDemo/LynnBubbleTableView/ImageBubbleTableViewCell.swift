//
//  ImageBubbleTableViewCell.swift
//  LynnBubbleTableViewDemo
//
//  Created by Colondee :D on 2015. 11. 4..
//  Copyright © 2015년 lou. All rights reserved.
//

import UIKit

class ImageBubbleTableViewCell: MyBubbleViewCell {

    @IBOutlet weak var imgData: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .None
//        self.imgData.layer.borderWidth = 1.0
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setBubbleData(data: LynnBubbleData) {
        
        self.lbTime.text = data.date._stringWithFormat("a h:mm")
        self.imgData.image = data.image
        
        func checkImageUpdated () {
            if data.imageLoaded {
                self.imgData.image = data.image
                NSNotificationCenter.defaultCenter().postNotificationName("_CellDidLoadImageNotification", object: self)
                return
            }else{
                _delay(0.5, closure: { () -> Void in
                    checkImageUpdated()
                })
            }
        }
        
        checkImageUpdated()

    }
}
